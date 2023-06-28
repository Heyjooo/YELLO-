//
//  NSObject+.swift
//  YELLO 연습
//
//  Created by 변희주 on 2023/06/26.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
