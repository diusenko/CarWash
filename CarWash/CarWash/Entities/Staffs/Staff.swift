//
//  Staff.swift
//  CarWash
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Staff<ProcessedObject: MoneyGiver>: Stateable, MoneyReceiver, MoneyGiver, Observable, CustomStringConvertible {
    
    enum State {
        case available
        case waitForProcessing
        case busy
    }
    
    var state: State {
        get { return self.atomicState.value }
        set {
            let oldValue = self.state
            
            if newValue == .available && self.state == .waitForProcessing && !self.processingObjectsIsEmpty {
                self.atomicState.value = .busy
                self.processingObjects.dequeue().do(self.asyncDoWork)
            } else {
                self.atomicState.value = newValue
            }
            self.notify(oldValue: oldValue, newValue: newValue)
        }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }

    var processingObjectsIsEmpty: Bool {
        return self.processingObjects.isEmpty
    }
    
    var observers = [Int: WeakObserver]()

    let id: Int
    
    private let atomicState = Atomic(State.available)
    private let atomicMoney = Atomic(0)
    private let queue: DispatchQueue
    private let durationOfWork: ClosedRange<Double>
    private let processingObjects = Queue<ProcessedObject>()
    
    init(
        id: Int,
        durationOfWork: ClosedRange<Double> = 0.0...1.0,
        queue: DispatchQueue = .background
    ) {
        self.id = id
        self.durationOfWork = durationOfWork
        self.queue = queue
    }
    
    func add(observer: StateObserver) {
        let weakObserver = WeakObserver(observer: observer)
        self.observers.updateValue(weakObserver, forKey: observer.id)
    }
    
    func remove(observer: StateObserver) {
        self.observers.removeValue(forKey: observer.id)
    }
    
    func notify(oldValue: Staff<ProcessedObject>.State, newValue: Staff<ProcessedObject>.State) {
        self.observers.forEach {
            $0.value.observer.do { observer in
                observer.valueChanged(subject: self, oldValue: oldValue, newValue: newValue)
            }
        }
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
    
    func performProcessing(object: ProcessedObject) { }
    
    func completeProcessing(object: ProcessedObject) { }
    
    func completePerformWork() {
        self.state = .waitForProcessing
    }
    
    func performWork(
        processedObject: ProcessedObject
    ) {
        self.atomicState.modify { state in
            if state == .available {
                state = .busy
                self.asyncDoWork(processedObject: processedObject)
            } else {
                self.processingObjects.enqueue(processedObject)
            }
        }
    }
    
    private func checkQueue() {
        if let processingObject = self.processingObjects.dequeue() {
            self.asyncDoWork(processedObject: processingObject)
        } else {
            self.completePerformWork()
        }
    }
    
    private func asyncDoWork(
        processedObject: ProcessedObject
    ) {
        self.queue.asyncAfter(deadline: .afterRandomInterval(in: self.durationOfWork)) {
            self.performProcessing(object: processedObject)
            self.completeProcessing(object: processedObject)
            self.checkQueue()
        }
    }
    
    var description: String {
        return "\(type(of: self))\(self.id)"
    }
    
    //SHIT
    class WeakObserver {
        
        weak var observer: StateObserver?
        
        init(observer: StateObserver) {
            self.observer = observer
        }
    }
}


