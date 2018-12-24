//
//  ObservableObject+Observer.swift
//  CarWash
//
//  Created by Usenko Dmitry on 12/18/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension ObservableObject {
    
    class Observer: Hashable, Cancellable {
        
        typealias Handler = (State) -> ()
        
        var hashValue: Int {
            return ObjectIdentifier(self).hashValue
        }
        
        var isCancelled: Bool {
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
