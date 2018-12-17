//
//  ObservableObject.swift
//  CarWash
//
//  Created by Student on 12/14/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class ObservableObject<State> {
    
    private var atomicObservers = Atomic([Observer]())
    
    func observer(handler: @escaping Observer.Handler) -> Observer {
        return self.atomicObservers.modify {
            let observer = Observer(sender: self, handler: handler)
            $0.append(observer)
            
            return observer
        }
    }
    
    func notify(state: State) {
        self.atomicObservers.modify {
            $0 = $0.filter { $0.isObserving }
            $0.forEach { $0.handler(state) }
        }
    }
}

extension ObservableObject {
    
    class Observer: Hashable {
        
        typealias Handler = (State) -> ()
        
        var hashValue: Int {
            return ObjectIdentifier(self).hashValue
        }
        
        var isObserving: Bool {
            return self.sender != nil
        }
        
        private weak var sender: ObservableObject?
        
        private(set) var handler: Handler
        
        init(sender: ObservableObject, handler: @escaping Handler) {
            self.sender = sender
            self.handler = handler
        }
        
        func cancel() {
            self.sender = nil
        }
        
        static func == (lhs: Observer, rhs: Observer) -> Bool {
            return lhs === rhs
        }
    }
}
