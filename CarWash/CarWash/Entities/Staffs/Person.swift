//
//  Staff.swift
//  CarWash
//
//  Created by Student on 12/11/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Person: Stateable, MoneyReceiver, MoneyGiver, Synchronizable, CustomStringConvertible  {
    
    enum State {
        case available
        case waitForProcessing
        case busy
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    var state: Person.State = .available
    
    private var atomicObservers = Atomic([StaffObserver]())
    
    let atomicState = Atomic(State.available)
    
    private let atomicMoney = Atomic(0)
    
    let id: Int
    
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
    
    func observer(handler: @escaping StaffObserver.Handler) -> StaffObserver {
        return self.atomicObservers.modify {
            let staffObserver = StaffObserver(sender: self, handler: handler)
            $0.append(staffObserver)
            staffObserver.handler(self.state)
            
            return staffObserver
        }
    }
    
    func notify(state: State){
        self.atomicObservers.modify {
            $0 = $0.filter { $0.IsObserving }
            $0.forEach {
                $0.handler(state)
            }
        }
    }
    
    var description: String {
        return "\(type(of: self))\(self.id)"
    }
}
