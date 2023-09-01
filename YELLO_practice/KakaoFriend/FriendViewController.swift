//
//  KakaoFriendViewController.swift
//  YELLO_practice
//
//  Created by 변희주 on 2023/07/01.
//

import UIKit

import SnapKit
import Then

final class FriendViewController: UIViewController {
    
    var friendsCountLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        setStyle()
        setLayout()
    }
    
    func setStyle() {
        view.backgroundColor = .white
        friendsCountLabel.do {
            $0.font = UIFont.boldSystemFont(ofSize: 30)
        }
    }
    
    func setLayout() {
        view.addSubview(friendsCountLabel)
        friendsCountLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
    }
    
}
