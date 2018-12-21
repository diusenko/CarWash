//
//  Staff.swift
//  Employee
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Staff<ProcessedObject: MoneyGiver>: Person, Processable {
    
    override var state: State {
        get { return self.atomicState.value }
        set {
            self.atomicState.modify {
                $0 = newValue
                self.notify(handler: $0)
            }
        }
    }
    
    private let queue: DispatchQueue
    private let durationOfWork: ClosedRange<Double>
    
    init(
        id: Int,
        durationOfWork: ClosedRange<Double> = 0.0...1.0,
        queue: DispatchQueue = .background
    ) {
        self.durationOfWork = durationOfWork
        self.queue = queue
        super.init(id: id)
    }
    
    func performProcessing(object: ProcessedObject) { }
    
    func completeProcessing(object: ProcessedObject) { }
    
    func completeProcessObject() {
        self.state = .waitForProcessing
    }
    
    func processObject(processedObject: ProcessedObject) {
        self.state = .busy
        self.queue.asyncAfter(deadline: .afterRandomInterval(in: self.durationOfWork)) {
            self.performProcessing(object: processedObject)
            self.completeProcessing(object: processedObject)
            self.completeProcessObject()
        }
    }
}
