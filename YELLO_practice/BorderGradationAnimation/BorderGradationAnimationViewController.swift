//
//  BorderGradationAnimationViewController.swift
//  YELLO_practice
//
//  Created by 변희주 on 2023/07/25.
//

import UIKit

import SnapKit
import Then

final class BorderGradationAnimationViewController: UIViewController {
    
    private enum Color {
        static var gradientColors = [
            UIColor.white,
            UIColor.white.withAlphaComponent(0.7),
            UIColor.white.withAlphaComponent(0.4),
            UIColor.white.withAlphaComponent(0.3),
            UIColor.white.withAlphaComponent(0.7),
            UIColor.white.withAlphaComponent(0.3),
            UIColor.white.withAlphaComponent(0.4),
            UIColor.white.withAlphaComponent(0.7),
        ]
    }
    
    private enum Constants {
        static let gradientLocation = [Int](0..<Color.gradientColors.count)
            .map(Double.init)
            .map { $0 / Double(Color.gradientColors.count) }
            .map(NSNumber.init)
        static let cornerRadius = 8.0
        static let cornerWidth = 2.0
        static let viewSize = CGSize(width: 100, height: 350)
    }
    
    private lazy var sampleView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = Constants.cornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }()
    
    private let buttonImage = UIImageView()
    
    private var timer: Timer?
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func animateBorderGradation() {
        // 1. 경계선에만 색상을 넣기 위해서 CAShapeLayer 인스턴스 생성
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(
            roundedRect: self.sampleView.bounds.insetBy(dx: Constants.cornerWidth, dy: Constants.cornerWidth),
            cornerRadius: self.sampleView.layer.cornerRadius
        ).cgPath
        shape.lineWidth = Constants.cornerWidth
        shape.cornerRadius = Constants.cornerRadius
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        // 2. conic 그라데이션 효과를 주기 위해서 CAGradientLayer 인스턴스 생성 후 mask에 CAShapeLayer 대입
        let gradient = CAGradientLayer()
        gradient.frame = self.sampleView.bounds
        gradient.type = .conic
        gradient.colors = Color.gradientColors.map(\.cgColor) as [Any]
        gradient.locations = Constants.gradientLocation
        gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.mask = shape
        gradient.cornerRadius = Constants.cornerRadius
        self.sampleView.layer.addSublayer(gradient)
        
        // 3. 매 0.2초마다 마치 circular queue처럼 색상을 번갈아서 바뀌도록 구현
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            gradient.removeAnimation(forKey: "myAnimation")
            let previous = Color.gradientColors.map(\.cgColor)
            let last = Color.gradientColors.removeLast()
            Color.gradientColors.insert(last, at: 0)
            let lastColors = Color.gradientColors.map(\.cgColor)
            
            let colorsAnimation = CABasicAnimation(keyPath: "colors")
            colorsAnimation.fromValue = previous
            colorsAnimation.toValue = lastColors
            colorsAnimation.repeatCount = 1
            colorsAnimation.duration = 0.2
            colorsAnimation.isRemovedOnCompletion = false
            colorsAnimation.fillMode = .both
            gradient.add(colorsAnimation, forKey: "myAnimation")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonImage.do {
            $0.image = .paymentButton
        }
        
        sampleView.addSubview(buttonImage)
        view.addSubview(sampleView)
        
        buttonImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sampleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(328)
            $0.height.equalTo(62)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.animateBorderGradation()
    }
    
}
