//
//  InstagramViewController.swift
//  YELLO_practice
//
//  Created by 변희주 on 2023/06/29.
//

import UIKit

import SnapKit
import Then

final class InstagramViewController: UIViewController {
    
    private let yellowView = UIView()
    private let yellowText = UILabel()
    private let yellowSticker = UIImageView()
    private let questionMark = UILabel()
    
    private let sharingButton = UIButton()
    private let sharingText = UILabel()
    private let instagramLogo = UIImageView()
    
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
        
        yellowView.do {
            $0.backgroundColor = .systemGray5
            $0.makeCornerRound(radius: 15)
        }
        
        yellowText.do {
            $0.text = "나는 너랑 한강에서 \n 돗자리 피고 치맥 \n 하고 싶어"
            let attrString = NSMutableAttributedString(string: $0.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 20
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            $0.attributedText = attrString
            $0.numberOfLines = 3
            $0.textColor = .black
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: 25)
        }
        
        yellowSticker.do {
            $0.image = .yellowSticker
        }
        
        questionMark.do {
            $0.text = "?"
            $0.textColor = .black
            $0.textAlignment = .center
        }
        
        sharingButton.do {
            $0.backgroundColor = .systemGray5
            $0.makeCornerRound(radius: 15)
            $0.addTarget(self, action: #selector(sharingButtonClicked), for: .touchUpInside)
        }
        
        sharingText.do {
            $0.text = "인스타그램 공유하기"
            $0.textColor = .black
            $0.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        instagramLogo.do {
            $0.image = .instagramLogo
        }
    }
    
    func setLayout() {
        view.addSubviews(yellowView, sharingButton)
        yellowView.addSubviews(yellowText, yellowSticker, questionMark)
        sharingButton.addSubviews(sharingText, instagramLogo)
        
        yellowView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(150)
            $0.height.equalTo(470)
            $0.leading.trailing.equalToSuperview().inset(17)
        }
        
        yellowText.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        yellowSticker.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(73)
            $0.height.equalTo(30)
        }
        
        questionMark.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        sharingButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(130)
            $0.leading.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(70)
        }
        
        instagramLogo.snp.makeConstraints {
            $0.size.equalTo(35)
            $0.leading.equalToSuperview().inset(80)
            $0.centerY.equalToSuperview()
        }
        
        sharingText.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(80)
        }
        
    }
    
    @objc
    func sharingButtonClicked() {
        if let storiesUrl = URL(string: "instagram-stories://share?source_application=6293738794007831") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                yellowView.do {
                    $0.makeCornerRound(radius: 0)
                }
                let renderer = UIGraphicsImageRenderer(size: yellowView.bounds.size)
                let renderImage = renderer.image { _ in
                    yellowView.drawHierarchy(in: yellowView.bounds, afterScreenUpdates: true)
                }

                guard let imageData = renderImage.pngData() else { return }
                let pasteboardItems: [String: Any] = [
                     "com.instagram.sharedSticker.backgroundImage": imageData,
                      // 스티커로 공유
//                    "com.instagram.sharedSticker.stickerImage": imageData,
//                    "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
//                    "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                ]
                
                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate : Date().addingTimeInterval(300)
                ]
                
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                
                UIApplication.shared.open(storiesUrl, options: [:], completionHandler: nil)
                
            } else {
                print("User doesn't have instagram on their device.")
            }
            
            yellowView.do {
                $0.makeCornerRound(radius: 15)
            }
        }
    }
    
}
