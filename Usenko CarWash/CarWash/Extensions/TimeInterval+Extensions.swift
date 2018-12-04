//
//  TimeInterval+Extensions.swift
//  CarWash
//
//  Created by Student on 10/26/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation


//XUYNYA
extension TimeInterval {
    
    static func randomInterval(in range: Range<Double>) -> TimeInterval {
        return .random(in: range)
    }
    
    static func randomInterval(in range: ClosedRange<Double>) -> TimeInterval {
        return .random(in: range)
    }
}
