//
//  Manager.swift
//  CarWash
//
//  Created by Student on 12/19/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class StaffManager<Object: Staff<ProcessedObject>, ProcessedObject: MoneyGiver>: ObservableObject<Object> {
    
    var processingObjectsIsEmpty: Bool {
        return self.processingObjects.isEmpty
    }
    
    private let weakObservers = Atomic([Person.Observer]())
    private let processingObjects = Queue<ProcessedObject>()
    private let objects = Atomic([Object]())
    
    init(objects: [Object]) {
        self.objects.value = objects
        super.init()
        self.attach()
    }
    
    func performWork(processedObject: ProcessedObject) {
        self.objects.transform {
            
            let availableObject = $0.first {
                $0.state == .available
            }
            
            let enqueueProcessingObject = { self.processingObjects.enqueue(processedObject) }
            
            if self.processingObjects.isEmpty {
                
                if let availableObject = availableObject {
                    availableObject.processObject(processedObject: processedObject)
                } else {
                    enqueueProcessingObject()
                }
            } else {
                enqueueProcessingObject()
            }
        }
    }

    private func attach() {
        weak var weakSelf = self
        
        self.weakObservers.value = self.objects.value.map { object in
            let weakWasherObserver = object.observer { [weak object] state in
                DispatchQueue.background.async {
                    switch state {
                    case .available:
                        weakSelf?.processingObjects.dequeue().apply(object?.processObject)
                    case .waitForProcessing:
                        object.apply(weakSelf?.notify)
                    case .busy: return
                    }
                }
            }
            return weakWasherObserver
        }
    }
}
