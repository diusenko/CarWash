//
//  Staff.swift
//  Employee
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Staff<ProcessedObject: MoneyGiver>: Person {
    
    override var state: State {
        get { return self.atomicState.value }
        set {
            self.atomicState.modify {
                guard $0 != newValue else { return }
                
                if newValue == .available && !self.processingObjectsIsEmpty {
                    $0 = .busy
                    self.processingObjects.dequeue().do(self.asyncDoWork)
                } else {
                    $0 = newValue
                }
                self.notify(state: $0)
            }
        }
    }
    
    var processingObjectsIsEmpty: Bool {
        return self.processingObjects.isEmpty
    }
    
    private let queue: DispatchQueue
    private let durationOfWork: ClosedRange<Double>
    private let processingObjects = Queue<ProcessedObject>()
    
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
    
    func completePerformWork() {
        self.atomicState.modify {
            if let processingObject = self.processingObjects.dequeue() {
                self.asyncDoWork(with: processingObject)
            } else {
                $0 = .waitForProcessing
                self.notify(state: $0)
            }
        }
    }
    
    func performWork(processedObject: ProcessedObject) {
        self.atomicState.modify { state in
            if state == .available {
                state = .busy
                self.asyncDoWork(with: processedObject)
            } else {
                self.processingObjects.enqueue(processedObject)
            }
        }
    }
    
    private func asyncDoWork(with processedObject: ProcessedObject) {
        self.queue.asyncAfter(deadline: .afterRandomInterval(in: self.durationOfWork)) {
            self.performProcessing(object: processedObject)
            self.completeProcessing(object: processedObject)
            self.completePerformWork()
        }
    }
}
