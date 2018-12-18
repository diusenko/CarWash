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