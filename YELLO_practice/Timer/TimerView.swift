//
//  TimerView.swift
//  YELLO_practice
//
//  Created by 변희주 on 2023/07/03.
//

import UIKit

import SnapKit
import Then

final class TimerView: UIView {
    
    private let infoLabel = UILabel()
    private let infoText = UILabel()
    
    private let timeLabel = UILabel()
    
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let animationName = "progressAnimation"
    private var timer: Timer?
    
    private var remainingSeconds: TimeInterval? {
        didSet {
            guard let remainingSeconds = self.remainingSeconds else { return }
            self.timeLabel.text = String(format: "%02d : %02d", Int(remainingSeconds/60), Int(remainingSeconds.truncatingRemainder(dividingBy: 60)))
        }
    }
    
    private var circularPath: UIBezierPath {
        UIBezierPath(
            arcCenter: CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0),
            radius: 100,
            startAngle: CGFloat(3 * Double.pi / 2),
            endAngle: CGFloat(-Double.pi / 2),
            clockwise: false // 시계 방향과 반대 방향을 나타내기 위해 clockwise 값을 false로 변경
        )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        
        start(duration: 2400)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        // TODO: UIBezierPath는 런타임마다 바뀌는 frame값을 참조하여 원의 윤곽 레이아웃을 알아야 하므로,
        // 이곳에 적용
        self.backgroundLayer.path = self.circularPath.cgPath
        self.progressLayer.path = self.circularPath.cgPath
    }
    
    func setUI() {
        setStyle()
        setLayout()
    }
    
    func setStyle() {
        self.backgroundColor = .black
        
        infoLabel.do {
            $0.textColor = .white
            $0.text = "다음 투표까지 남은 시간"
            $0.font = UIFont.boldSystemFont(ofSize: 30)
        }
        
        infoText.do {
            $0.textColor = .systemGray4
            $0.text = "시간이 지나면 다시 투표할 수 있어요!"
            $0.font = UIFont.boldSystemFont(ofSize: 17)
            
        }
        
        timeLabel.do {
            $0.textColor = .yellow
            $0.text = "40분"
            $0.font = UIFont.boldSystemFont(ofSize: 35)
        }
        
        backgroundLayer.do {
            $0.path = self.circularPath.cgPath
            $0.fillColor = UIColor.clear.cgColor
            $0.lineCap = .round
            $0.lineWidth = 15.0
            $0.strokeStart = 0
            $0.strokeColor = UIColor.systemGray.cgColor
            $0.zPosition = 0
        }
        
        progressLayer.do {
            $0.path = self.circularPath.cgPath
            $0.fillColor = UIColor.clear.cgColor
            $0.lineCap = .round
            $0.lineWidth = 15.0
            $0.strokeStart = 0
            $0.strokeEnd = 1
            $0.strokeColor = UIColor.yellow.cgColor
            $0.zPosition = 1
        }
    }
    
    func setLayout() {
        self.addSubviews(self.infoLabel, self.infoText, self.timeLabel)
        self.layer.addSublayer(self.backgroundLayer)
        self.layer.addSublayer(self.progressLayer)
        
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(150)
        }
        
        infoText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoLabel.snp.bottom).offset(20)
        }
        
        timeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
    
    
    func start(duration: TimeInterval) {
        self.remainingSeconds = duration
        // timer
        self.timer?.invalidate()
        let startDate = Date()
        self.timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                let elapsedSeconds = round(abs(startDate.timeIntervalSinceNow))
                let remainingSeconds = max(duration - elapsedSeconds, 0)
                guard remainingSeconds > 0 else {
                    self?.stop()
                    return
                }
                self?.remainingSeconds = remainingSeconds
                self?.animateProgress(to: Float(remainingSeconds / duration))
            }
        )
    }
    
    func stop() {
        self.timer?.invalidate()
        self.progressLayer.removeAnimation(forKey: self.animationName)
        self.remainingSeconds = 2400
    }
    
    func animateProgress(to value: Float) {
        self.progressLayer.removeAnimation(forKey: self.animationName)
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 1
        circularProgressAnimation.fromValue = self.progressLayer.presentation()?.strokeEnd ?? 1.0
        circularProgressAnimation.toValue = value
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        self.progressLayer.add(circularProgressAnimation, forKey: self.animationName)
    }
    
}
