//
//  Int+Extension.swift
//  CarWash
//
//  Created by Usenko Dmitry on 10/26/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension Strideable where Self.Stride: SignedInteger & Comparable, Self: ExpressibleByIntegerLiteral {
    
    func times(_ execute: F.VoidExecute) {
        (0..<self).forEach { _ in
            execute()
        }
    }
}
