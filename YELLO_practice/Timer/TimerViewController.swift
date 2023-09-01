//
//  TimerViewController.swift
//  YELLO_practice
//
//  Created by 변희주 on 2023/07/03.
//

import UIKit

final class TimerViewController: UIViewController {
    
    private let originView = TimerView()
    
    override func loadView() {
        self.view = originView
    }
    
}
