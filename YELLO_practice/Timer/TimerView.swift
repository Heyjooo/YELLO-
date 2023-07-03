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
            startAngle: CGFloat(-Double.pi / 2),
            endAngle: CGFloat(3 * Double.pi / 2),
            clockwise: true
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
            $0.lineWidth = 13.0
            $0.strokeEnd = 1.0
            $0.strokeColor = UIColor.systemGray.cgColor
        }
        
        progressLayer.do {
            $0.path = self.circularPath.cgPath
            $0.fillColor = UIColor.clear.cgColor
            $0.lineCap = .round
            $0.lineWidth = 13.0
            $0.strokeEnd = 0
            $0.strokeColor = UIColor.yellow.cgColor
        }
        
    }
    
    func setLayout() {
        self.addSubviews(self.infoLabel, self.infoText, self.timeLabel)
        self.layer.addSublayer(self.backgroundLayer)
        self.layer.addSublayer(self.progressLayer)

        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(180)
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
          let remainingSeconds = duration - round(abs(startDate.timeIntervalSinceNow))
          guard remainingSeconds >= 0 else {
            self?.stop()
            return
          }
          self?.remainingSeconds = remainingSeconds
        }
      )
      
      // animation
      self.progressLayer.removeAnimation(forKey: self.animationName)
      let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
      circularProgressAnimation.duration = duration
      circularProgressAnimation.toValue = 1
      circularProgressAnimation.fillMode = .forwards
      circularProgressAnimation.isRemovedOnCompletion = false
      self.progressLayer.add(circularProgressAnimation, forKey: self.animationName)
    }
        
    func stop() {
      self.timer?.invalidate()
      self.progressLayer.removeAnimation(forKey: self.animationName)
      self.remainingSeconds = 2400
    }
    
}
