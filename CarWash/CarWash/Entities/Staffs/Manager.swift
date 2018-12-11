//
//  Manager.swift
//  CarWash
//
//  Created by Дмитрий Усенко on 13.11.2018.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Manager<ProcessedObject: MoneyGiver & Stateable>: Employee<ProcessedObject> {
    
    override func completeProcessing(object: ProcessedObject) {
        print("\(self) served \(object) and has \(self.money)$")
        object.state = .available
    }
    
    override func performProcessing(object: ProcessedObject) {
        self.receiveMoney(from: object)
    }
}
