//
//  LoginViewController.swift
//  YELLO 연습
//
//  Created by 변희주 on 2023/06/29.
//

import UIKit

import SnapKit
import Then

import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

import Kingfisher

final class LoginViewController: UIViewController {
    
    private let welcomeLabel = UILabel()
    private let kakaoLoginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        setStyle()
        setLayout()
    }
    
    func setStyle() {
        view.backgroundColor = .yellow
        welcomeLabel.do {
            $0.text = "YELL:O\n회원가입하기"
            $0.numberOfLines = 2
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: 40)
        }
        
        kakaoLoginButton.do {
            $0.setImage(.kakaoLogInButton, for: .normal)
            $0.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        }
    }
    
    func setLayout() {
        view.addSubviews(welcomeLabel, kakaoLoginButton)
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(186)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(500)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel).offset(500)
            $0.leading.trailing.equalToSuperview().inset(14)
            $0.height.equalTo(60)
        }
    }
    
    @objc
    func clickButton(_ sender: UIButton) {
        // isKakaoTalkLoginAvailable() : 카톡 설치 되어있으면 true
        if (UserApi.isKakaoTalkLoginAvailable()) {
            
            //카톡 설치되어있으면 -> 카톡으로 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("카카오톡으로 로그인 성공")
                    
                    _ = oauthToken
                    self.getUserInfo()
                    
                }
            }
        } else {
            
            // 카톡 없으면 -> 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    print("카카오 계정으로 로그인 성공")
                    
                    _ = oauthToken
                    self.getUserInfo()
                }
            }
        }
    }
    
    func getUserInfo() {
        //사용자 정보 불러옴
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            
            guard let profileImageUrl = user?.kakaoAccount?.profile?.profileImageUrl else { return }
            guard let name = user?.kakaoAccount?.profile?.nickname else { return }
            
            let nextViewController = ProfileViewController()
            nextViewController.profileImage.kf.setImage(with: profileImageUrl)
            nextViewController.userName.text = "USER NAME : " + name
            
            self.navigationController?.pushViewController(nextViewController, animated: true)
            self.navigationController?.navigationBar.isHidden = true
            
            print("me() success")
            
        }
    }
}
