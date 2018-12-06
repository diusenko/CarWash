//
//  WashServise.swift
//  CarWash
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class WashService: StateObserver {
    
    private let accountant: Accountant
    private let director: Director
    private let id: Int
    private let washers: Atomic<[Washer]>
    private let cars = Queue<Car>()
    
    init(
        id: Int,
        accountant: Accountant,
        director: Director,
        washers: [Washer]
    ) {
        self.id = id
        self.accountant = accountant
        self.washers = Atomic(washers)
        self.director = director
        washers.forEach { washer in
            washer.observer = self
        }
        self.accountant.observer = self
        self.director.observer = self
    }
    
    func washCar(_ car: Car) {
        self.washers.transform {
            let availableWasher = $0.first {
                $0.state == .available
            }
            
            let enqueueCar = { self.cars.enqueue(car) }
            
            if self.cars.isEmpty {
                if let availableWasher = availableWasher {
                    availableWasher.performWork(processedObject: car)
                } else {
                    enqueueCar() // duplication
                }
            } else {
                enqueueCar() // duplication
            }
        }
    }
    
    func valueChanged<T>(subject: Staff<T>, oldValue: Staff<T>.State) {
        if let washer = subject as? Washer  {
            if washer.state == .available {
                self.cars.dequeue().do(washer.performWork)
            } else if washer.state == .waitForProcessing {
                self.accountant.performWork(processedObject: washer)
            }
        } else if let accountant = subject as? Accountant {
            if accountant.state == .waitForProcessing {
                self.director.performWork(processedObject: accountant)
            } else if accountant.state == .available && oldValue == .waitForProcessing && !accountant.processingObjectsIsEmpty {
                accountant.state = .busy
                accountant.checkQueue()
            }
        }
    }
}
