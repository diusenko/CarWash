//
//  Director.swift
//  CarWash
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Director: Manager<Accountant> {
    
    override func completeProcessObject() {
        self.state = .available
    }
}
