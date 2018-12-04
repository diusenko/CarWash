//
//  Atomic.swift
//  CarWash
//
//  Created by Student on 10/31/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Atomic<Value> {
    
    public typealias ValueType = Value
    public typealias PropertyObserver = ((old: Value, new: Value)) -> ()
    
    public var value: ValueType {
        get { return self.transform { $0 } }
        set { self.modify { $0 = newValue } }
    }
    
    private var mutableValue: ValueType
    
    private let didSet: PropertyObserver?
    private let lock: NSRecursiveLock
    
    init(
        _ value: ValueType,
        lock: NSRecursiveLock = NSRecursiveLock(),
        didSet: PropertyObserver? = nil
    ) {
        self.mutableValue = value
        self.lock = lock
        self.didSet = didSet
    }
    
    @discardableResult
    public func modify<Result>(_ action: (inout ValueType) -> Result) -> Result {
        return self.lock.locked {
            let oldValue = self.mutableValue
            
            defer {
                self.didSet?((old: oldValue, new: self.mutableValue))
            }
            
            return action(&self.mutableValue)
        }
    }
    
    func transform<Result>(_ action: (ValueType) -> Result) -> Result {
        return self.lock.locked {
            action(self.mutableValue)
        }
    }
}
