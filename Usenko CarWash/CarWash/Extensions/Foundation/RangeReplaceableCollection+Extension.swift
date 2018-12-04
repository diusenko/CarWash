//
//  +Extension.swift
//  CarWash
//
//  Created by Student on 10/26/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection {
    
    mutating func safeRemoveFirst() -> Element? {
        return self.isEmpty ? nil : self.removeFirst()
    }
}
