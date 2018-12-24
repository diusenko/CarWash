//
//  Car.swift
//  CarWash
//
//  Created by Usenko Dmitry on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Car: MoneyGiver {
    
    enum State {
        case clean
        case dirty
    }
    
    var state: State {
        get { return self.atomicState.value }
        set {
            self.atomicState.value = newValue
        }
    }
    
    private let atomicState = Atomic(State.dirty)
    private let atomicMoney = Atomic(0)
    
    init(money: Int) {
        self.atomicMoney.value = money
    }
    
    func giveMoney() -> Int {
        defer {
            self.atomicMoney.value = 0
        }
        
        return self.atomicMoney.value
    }
}
