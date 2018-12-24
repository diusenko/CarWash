//
//  Optional+Extension.swift
//  CarWash
//
//  Created by Usenko Dmitry on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension Optional {
    
    func `do`(_ execute: (Wrapped) -> ()) {
        self.map(execute)
    }
    
    func apply<Result>(_ transform: ((Wrapped) -> (Result))?) -> Result? {
        return self.flatMap { transform?($0) }
    }
}



