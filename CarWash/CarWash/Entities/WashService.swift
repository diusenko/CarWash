//
//  WashServise.swift
//  CarWash
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class WashService {
    
    let id: Int
    
    private let accountant: Accountant
    private let director: Director
    private let washers: Atomic<[Washer]>
    private let cars = Queue<Car>()
    
    private var weakObservers = Atomic([Person.Observer]())
    
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
        self.attach()
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
                    enqueueCar()
                }
            } else {
                enqueueCar()
            }
        }
    }
    
    private func attach() {
        weak var weakSelf = self
        
        self.weakObservers.value = self.washers.value.map { washer in
            let weakWasherObserver = washer.observer { [weak washer] in
                switch $0 {
                case .available:
                    self.asyncDoEmployWork {
                        weakSelf?.cars.dequeue().apply(washer?.performWork)
                    }
                case .waitForProcessing:
                    self.asyncDoEmployWork {
                        washer.apply(weakSelf?.accountant.performWork)
                    }
                case .busy: return
                }
            }
            
            return weakWasherObserver
        }
        
        let weakAccountantObserver = self.accountant.observer {
            switch $0 {
            case .available: return
            case .waitForProcessing:
                self.asyncDoEmployWork {
                    (weakSelf?.accountant).apply(weakSelf?.director.performWork)
                }
            case .busy: return
            }
        }
        self.weakObservers.value.append(weakAccountantObserver)
    }
    
    private func asyncDoEmployWork(execute: @escaping F.VoidExecute) {
        DispatchQueue.background.async { execute() }
    }
}
