//
//  Optional+Extension.swift
//  CarWash
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension Optional {
    
    func `do`(_ execute: (Wrapped) -> ()) {
        self.map(execute)
    }
}



