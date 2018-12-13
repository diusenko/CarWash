//
//  StaffObserver.swift
//  CarWash
//
//  Created by Student on 12/12/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class StaffObserver: Hashable {
    
    typealias Handler = (Person.State) -> ()
    
    var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    var IsObserving: Bool {
        return self.sender != nil
    }
    
    private weak var sender: Person?
    private(set) var handler: Handler
    
    init(sender: Person, handler: @escaping Handler) {
        self.sender = sender
        self.handler = handler
    }
    
    func cancel() {
        self.sender = nil
    }
    
    static func == (lhs: StaffObserver, rhs: StaffObserver) -> Bool {
        return lhs === rhs
    }
}
