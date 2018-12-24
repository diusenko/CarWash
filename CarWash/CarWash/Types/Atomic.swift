//
//  Atomic.swift
//  CarWash
//
//  Created by Usenko Dmitry on 10/31/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Atomic<Value> {
    
    public typealias ValueType = Value
    public typealias PropertyObserver = ((old: ValueType, new: ValueType)) -> ()
    
    public var value: ValueType {
        get { return self.transform { $0 } }
        set { self.modify { $0 = newValue } }
    }
    
    private var mutableValue: ValueType
    
    private let didSet: PropertyObserver?
    private let willSet: PropertyObserver?
    private let lock: NSRecursiveLock
    
    init(
        _ value: ValueType,
        lock: NSRecursiveLock = NSRecursiveLock(),
        willSet: PropertyObserver? = nil,
        didSet: PropertyObserver? = nil
    ) {
        self.mutableValue = value
        self.lock = lock
        self.didSet = didSet
        self.willSet = willSet
    }
    
    @discardableResult
    public func modify<Result>(_ action: (inout ValueType) -> Result) -> Result {
        return self.lock.locked {
            let oldValue = self.mutableValue
            var newValue = self.mutableValue
            
            let result = action(&newValue)
            
            self.willSet?((old: oldValue, new: newValue))
            self.mutableValue = newValue
            
            defer {
                self.didSet?((old: oldValue, new: self.mutableValue))
            }
            
            return result
        }
    }
    
    func transform<Result>(_ action: (ValueType) -> Result) -> Result {
        return self.lock.locked {
            action(self.mutableValue)
        }
    }
}
