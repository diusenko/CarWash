//
//  Staff.swift
//  CarWash
//
//  Created by Usenko Dmitry on 12/11/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Person: ObservableObject<Person.State>, Stateable, MoneyReceiver, MoneyGiver, CustomStringConvertible  {
    
    enum State {
        case available
        case waitForProcessing
        case busy
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    var state: Person.State = .available
    
    let atomicState = Atomic(State.available)
    let id: Int
    
    private let atomicMoney = Atomic(0)
    
    deinit {
        print("deinit \(self)")
    }
    
    init(id: Int) {
        self.id = id
    }
    
    func giveMoney() -> Int {
        return self.atomicMoney.modify { money in
            defer { money = 0 }
            
            return money
        }
    }
    
    func receive(money: Int) {
        self.atomicMoney.modify {
            $0 += money
        }
    }
    
    var description: String {
        return "\(type(of: self))\(self.id)"
    }
}
