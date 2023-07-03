//
//  TabBarViewController.swift
//  YELLO_practice
//
//  Created by 변희주 on 2023/07/03.
//

import UIKit

import SnapKit
import Then

// MARK: - TabBar

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setTabBar()
    }
    
    func setTabBar() {
        
        tabBar.barTintColor = UIColor.white // TabBar 의 배경 색
        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor.white
        
        
        // MARK: - firstViewController
        
        let firstViewController = UINavigationController(rootViewController: TimerViewController())
        firstViewController.tabBarItem = UITabBarItem(title: "", image: .actions, selectedImage: .actions)
        
        // MARK: - secondViewController
        
        let secondViewController = UINavigationController(rootViewController: InvitingFriendViewController())
        secondViewController.tabBarItem = UITabBarItem(title: "", image: .checkmark , selectedImage: .checkmark)
        
        // MARK: - ThirdViewController
        
        let thirdViewController = UINavigationController(rootViewController: LoginViewController())
        thirdViewController.tabBarItem = UITabBarItem(title: "", image: .actions , selectedImage: .actions)
        
        // MARK: - FourthViewController
        
        let fourthViewController = UINavigationController(rootViewController: InstagramViewController())
        fourthViewController.tabBarItem = UITabBarItem(title: "", image: .checkmark , selectedImage: .checkmark)
        
        // MARK: - FifthViewController
        
        let fifthViewController = UINavigationController(rootViewController: LottieViewController())
        fifthViewController.tabBarItem = UITabBarItem(title: "", image: .actions , selectedImage: .actions)
        
        self.viewControllers = [firstViewController,
                                secondViewController,
                                thirdViewController,
                                fourthViewController,
                                fifthViewController]
    }
    
    // MARK: - TabBar height 조절
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = 75
        tabFrame.origin.y = self.view.frame.size.height - 60
        self.tabBar.frame = tabFrame
    }
    
}

