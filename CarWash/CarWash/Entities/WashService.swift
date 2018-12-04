//
//  WashServise.swift
//  CarWash
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class WashService {
    
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
        self.accountant.eventHandler = { self.doDirectorWork(accountant: self.accountant) }
        washers.forEach { washer in
            washer.eventHandler = {
                self.doAccountantWork(washer: washer)
                //self.cars.dequeue().do { self.doWasherWork(washer: washer, car: $0) }
            }
        }
    }
    
    func washCar(_ car: Car) {
        self.washers.transform {
            let availableWasher = $0.first {
                $0.state == .available
            }
            
            let enqueueCar = { self.cars.enqueue(car) }
            
            if cars.isEmpty {
                if let availableWasher = availableWasher {
                    self.doWasherWork(washer: availableWasher, car: car)
                } else {
                    enqueueCar() // duplication
                }
            } else {
                enqueueCar() // duplication
            }
        }
    }
    
    private func doWasherWork(washer: Washer, car: Car) {
        washer.performWork(processedObject: car)
    }
    
    private func doAccountantWork(washer: Washer) {
        self.accountant.performWork(processedObject: washer)
    }
    
    private func doDirectorWork(accountant: Accountant) {
        self.director.performWork(processedObject: accountant)
    }
}
