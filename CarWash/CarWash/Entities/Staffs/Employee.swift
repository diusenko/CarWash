//
//  Staff.swift
//  Employee
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Employee<ProcessedObject: MoneyGiver>: Stateable, MoneyReceiver, MoneyGiver, CustomStringConvertible {
    
    class StaffObserver: Equatable {
        
        static func == (lhs: Employee<ProcessedObject>.StaffObserver, rhs: Employee<ProcessedObject>.StaffObserver) -> Bool {
            return lhs === rhs
        }
        
        typealias Handler = (State) -> ()
        
        var IsObserving: Bool {
            return self.sender != nil
        }
        
        private weak var sender: Employee?
        fileprivate let handler: Handler
        
        init(sender: Employee, handler: @escaping Handler) {
            self.sender = sender
            self.handler = handler
        }
        
        func cancel() {
            self.sender = nil
        }
        
    }
    
    var observers = ObserversCollection()
    
    class ObserversCollection {
        
        private var atomicObservers = Atomic([StaffObserver]())
        
        func add(observer: StaffObserver) {
            self.atomicObservers.modify {
                $0.append(observer)
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
    }
    
    func observer(handler: @escaping StaffObserver.Handler) {
        let staffObserver = StaffObserver(sender: self, handler: handler)
        observers.add(observer: staffObserver)
    }
    
    enum State {
        case available
        case waitForProcessing
        case busy
    }
    
    var state: State {
        get { return self.atomicState.value }
        set {
            guard self.state != newValue else { return }
            
            if newValue == .available && self.state == .waitForProcessing && !self.processingObjectsIsEmpty {
                self.atomicState.value = .busy
                self.processingObjects.dequeue().do(self.asyncDoWork)
            } else {
                self.atomicState.value = newValue
            }
            
            self.observers.notify(state: newValue)
        }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }

    var processingObjectsIsEmpty: Bool {
        return self.processingObjects.isEmpty
    }

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
        if let processingObject = self.processingObjects.dequeue() {
            self.asyncDoWork(processedObject: processingObject)
        } else {
            self.state = .waitForProcessing
        }
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
    
    private func asyncDoWork(
        processedObject: ProcessedObject
    ) {
        self.queue.asyncAfter(deadline: .afterRandomInterval(in: self.durationOfWork)) {
            self.performProcessing(object: processedObject)
            self.completeProcessing(object: processedObject)
            self.completePerformWork()
        }
    }
    
    var description: String {
        return "\(type(of: self))\(self.id)"
    }
}
