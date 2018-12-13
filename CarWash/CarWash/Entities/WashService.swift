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
    let id: Int
    private let washers: Atomic<[Washer]>
    private let cars = Queue<Car>()
    private var weakObservers = [StaffObserver]()
    
    deinit {
        print("deinit")
        self.weakObservers.forEach {
            $0.cancel()
        }
    }
    
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
    
    func attach() {
        self.washers.value.forEach { washer in
            let weakWasherObserver = washer.observer { [weak self, weak washer] in
                switch $0 {
                case .available: self?.cars.dequeue().do { washer?.performWork(processedObject: $0) }
                case .waitForProcessing: washer.apply(self?.accountant.performWork)
                case .busy: return
                }
            }
            self.weakObservers.append(weakWasherObserver)
        }
        
        let weakAccountantObserver = self.accountant.observer { [weak self] in
            if $0 == .waitForProcessing {
                (self?.accountant).apply(self?.director.performWork)
            }
        }
        self.weakObservers.append(weakAccountantObserver)
    }
}
