//
//  1eqw.swift
//  CarWash
//
//  Created by Usenko Dmitry on 10/31/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension NSLocking {
    
    func locked<Result>(_ execute: () -> Result) -> Result {
        self.lock()
        defer { self.unlock() }
        
        return execute()
    }
}
