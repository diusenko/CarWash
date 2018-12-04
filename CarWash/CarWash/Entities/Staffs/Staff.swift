//
//  Staff.swift
//  CarWash
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Staff<ProcessedObject: MoneyGiver>: Stateable, MoneyReceiver, MoneyGiver, CustomStringConvertible {
    
    enum State {
        case available
        case waitForProcessing
        case busy
    }
    
    var state: State {
        get { return self.atomicState.value }
        set {
            self.atomicState.modify {
                if $0 == .busy && newValue == .waitForProcessing {
                    self.eventHandler?()
                    $0 = .busy
                } else if $0 == .waitForProcessing && newValue == .available && !self.processingObjects.isEmpty {
                    self.processingObjects.dequeue().do(performProcessing)
                    $0 = .busy
                } else {
                    $0 = newValue
                }
            }
        }
    }
    
    var money: Int {
        return self.atomicMoney.value
    }
    
    var eventHandler: F.Completion?

    let id: Int
    private let atomicState = Atomic(State.available)
   
    private let queue: DispatchQueue
    private let durationOfWork: ClosedRange<Double>
    private let atomicMoney = Atomic(0)
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
    
    private func asyncDoWork(
        processedObject: ProcessedObject
    ) {
        self.queue.asyncAfter(deadline: .afterRandomInterval(in: self.durationOfWork)) {
            self.performProcessing(object: processedObject)
            self.completeProcessing(object: processedObject)
            
            if self.processingObjects.isEmpty {
                self.completePerformWork()
            } else {
                self.processingObjects.dequeue().do {
                    self.asyncDoWork(processedObject: $0)
                }
            }
        }
    }
    
    var description: String {
        return "\(type(of: self))\(self.id)"
    }
}
