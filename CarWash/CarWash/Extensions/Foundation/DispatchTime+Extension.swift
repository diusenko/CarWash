//
//  DispatchTime+Extensions.swift
//  CarWash
//
//  Created by Usenko Dmitry on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension DispatchTime {
    
    static func after(interval: TimeInterval) -> DispatchTime {
        return .now() + interval
    }
    
    static func afterRandomInterval(in range: Range<Double>) -> DispatchTime {
        return self.after(interval: .random(in: range))
    }
    
    static func afterRandomInterval(in range: ClosedRange<Double>) -> DispatchTime {
        return self.after(interval: .random(in: range))
    }
}
