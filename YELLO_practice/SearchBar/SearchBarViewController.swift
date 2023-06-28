//
//  SearchBarViewController.swift
//  YELLO 연습
//
//  Created by 변희주 on 2023/06/26.
//

import UIKit
import SnapKit
import Then

final class SearchBarViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private var arr = ["홍익대학교", "이화여자대학교", "숭실대학교", "동국대학교", "연세대학교", "서울대학교", "고려대학교", "숙명여자대학교", "전남대학교", "서강대학교", "성균관대학교", "한양대학교", "중앙대학교", "경희대학교", "시립대학교", "건국대학교", "광운대학교", "한성대학교", "국민대학교", "한국외국어대학교"]
    
    private var filteredArr: [String] = []
    
    private var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setLayout()
        setupSearchController()
        setupTableView()
    }
    
    func setStyle() {
        view.backgroundColor = .systemGray6
    }
    
    func setLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "소속 대학교를 검색하세요"
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}

extension SearchBarViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredArr.count : arr.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if isFiltering {
            cell.textLabel?.text = filteredArr[indexPath.row]
        } else {
            cell.textLabel?.text = arr[indexPath.row]
        }
        return cell
    }
}

extension SearchBarViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filteredArr = arr.filter { $0.contains(text) }
        tableView.reloadData()
    }
}
