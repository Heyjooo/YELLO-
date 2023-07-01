//
//  ProfileViewController.swift
//  YELLO_practice
//
//  Created by 변희주 on 2023/06/29.
//

import UIKit

import SnapKit
import Then
import KakaoSDKUser
import KakaoSDKTalk
import KakaoSDKCommon

final class ProfileViewController: UIViewController {

    private let welcomeLabel = UILabel()
    let userName = UILabel()
    let profileImage = UIImageView()
    private let logoutButton = UIButton()
    private let linkFriendButton = UIButton()
    
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
        
        welcomeLabel.do {
            $0.text = "YELL:O에 가입하신걸 \n 환영합니다!"
            $0.numberOfLines = 2
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: 30)
        }
         
        userName.do {
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        linkFriendButton.do {
            $0.setTitle("카카오톡으로 친구 연결하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .yellow
            $0.makeCornerRound(radius: 7)
            $0.addTarget(self, action: #selector(linkFriendButtonClicked), for: .touchUpInside)
        }
        
        logoutButton.do {
            $0.setTitle("로그아웃", for: .normal)
            $0.setTitleColor(.yellow, for: .normal)
            $0.backgroundColor = .brown
            $0.makeCornerRound(radius: 7)
            $0.addTarget(self, action: #selector(logoutButtonClicked), for: .touchUpInside)
        }
        
    }
    
    func setLayout() {
        view.addSubviews(welcomeLabel, profileImage, userName, linkFriendButton, logoutButton)
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(130)
            $0.centerX.equalToSuperview()
        }
        
        profileImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(200)
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(70)
        }
        
        userName.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImage.snp.bottom).offset(20)
        }
        
        linkFriendButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(200)
            $0.height.equalTo(70)
            $0.leading.trailing.equalToSuperview().inset(14)
        }
        
        logoutButton.snp.makeConstraints{
            $0.top.equalTo(linkFriendButton.snp.bottom).offset(20)
            $0.height.equalTo(70)
            $0.leading.trailing.equalToSuperview().inset(14)
        }
    }
    
    @objc
    func logoutButtonClicked() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @objc
    func linkFriendButtonClicked() {
        TalkApi.shared.friends {(friends, error) in
            if let error = error {
                print(error)
            }
            else {
                //do something
                _ = friends
                
                guard let count = friends?.totalCount else { return }
                
                let nextViewController = FriendViewController()
                nextViewController.friendsCountLabel.text = String(count)
                
                self.navigationController?.pushViewController(nextViewController, animated: true)
                self.navigationController?.navigationBar.isHidden = true
            }
        }
    }

}
