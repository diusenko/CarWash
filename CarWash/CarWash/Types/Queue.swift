//
//  Queue.swift
//  CarWash
//
//  Created by Usenko Dmitry on 10/29/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Queue<Element> {
    
    private let elements = Atomic([Element]())
    
    func enqueue(_ value: Element) {
        self.elements.modify { $0.append(value) }
    }
    
    func dequeue() -> Element? {
        return self.elements.modify { $0.safeRemoveFirst() }
    }
    
    var isEmpty: Bool {
        return self.elements.value.isEmpty
    }
    
    var count: Int {
        return self.elements.value.count
    }
}
