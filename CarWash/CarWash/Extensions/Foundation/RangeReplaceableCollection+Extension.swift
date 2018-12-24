//
//  +Extension.swift
//  CarWash
//
//  Created by Usenko Dmitry on 10/26/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension RangeReplaceableCollection {
    
    mutating func safeRemoveFirst() -> Element? {
        return self.isEmpty ? nil : self.removeFirst()
    }
}
