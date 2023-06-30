//
//  InvitingFreindViewController.swift
//  YELLO_practice
//
//  Created by 변희주 on 2023/06/30.
//

import UIKit

import SnapKit
import Then

import KakaoSDKCommon
import KakaoSDKTemplate
import KakaoSDKShare

final class InvitingFriendViewController: UIViewController {

    private let cannotStartingText = UILabel()
    private let friends = UIImageView()
    private let fourFriendsText = UILabel()
    private let invitingButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    func setUI() {
        setStyle()
        setLayout()
    }
    
    func setStyle() {
        view.backgroundColor = .systemGray5
        cannotStartingText.do {
            $0.text = "친구들이  모이지 않아서 \n 투표를 시작할 수 없어ㅠ"
            $0.numberOfLines = 2
            $0.textColor = .black
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.textAlignment = .center
        }
        
        friends.do {
            $0.image = .friends
        }
        
        fourFriendsText.do {
            $0.text = "친구 4명 이상이 모이면 \n 시작할 수 있어!"
            $0.numberOfLines = 2
            $0.textColor = .black
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            $0.textAlignment = .center
        }
        
        invitingButton.do {
            $0.setTitle("카카오톡 친구 초대하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            $0.backgroundColor = .systemGray4
            $0.makeCornerRound(radius: 15)
            $0.addTarget(self, action: #selector(invitingButtonClicked), for: .touchUpInside)
        }
    }
    
    func setLayout() {
        view.addSubviews(cannotStartingText,
                         friends,
                         fourFriendsText,
                         invitingButton)
        
        cannotStartingText.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.centerX.equalToSuperview()
        }
        
        friends.snp.makeConstraints {
            $0.size.equalTo(158)
            $0.top.equalTo(cannotStartingText.snp.bottom).offset(70)
            $0.centerX.equalToSuperview()
        }
        
        fourFriendsText.snp.makeConstraints {
            $0.top.equalTo(friends.snp.bottom).offset(70)
            $0.centerX.equalToSuperview()
        }
        
        invitingButton.snp.makeConstraints {
            $0.top.equalTo(fourFriendsText.snp.bottom).offset(90)
            $0.leading.trailing.equalToSuperview().inset(63)
            $0.height.equalTo(53)
        }
    }
    
    @objc
    func invitingButtonClicked() {
        let templateId = 95562

        // 카카오톡 설치여부 확인
        if ShareApi.isKakaoTalkSharingAvailable() {
            // 카카오톡으로 카카오톡 공유 가능
            ShareApi.shared.shareCustom(templateId: Int64(templateId), templateArgs:["title":"제목입니다.", "description":"설명입니다."]) {(sharingResult, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("shareCustom() success.")
                    if let sharingResult = sharingResult {
                        UIApplication.shared.open(sharingResult.url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
        
        else {
            // 카카오톡 미설치: 웹 공유 사용 권장
            
            if ShareApi.shared.makeCustomUrl(templateId: Int64(templateId), templateArgs:["title":"제목입니다.", "description":"설명입니다."]) != nil {
                print("error")
            }
        }
    }
    
}
