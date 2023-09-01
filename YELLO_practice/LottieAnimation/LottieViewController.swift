//
//  LottieViewController.swift
//  YELLO_practice
//
//  Created by 변희주 on 2023/07/03.
//

import UIKit
import Lottie

final class LottieViewController: UIViewController {
    
    private var animationView: LottieAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 2. Start AnimationView with animation name (without extension)
        
        animationView = .init(name: "coffee")
        
        animationView!.frame = view.bounds
        
        // 3. Set animation content mode
        
        animationView!.contentMode = .scaleAspectFit
        
        // 4. Set animation loop mode
        
        animationView!.loopMode = .loop
        
        // 5. Adjust animation speed
        
        animationView!.animationSpeed = 1.1
        
        view.addSubview(animationView!)
        
        // 6. Play animation
        
        animationView!.play()
    }
    
    
}
