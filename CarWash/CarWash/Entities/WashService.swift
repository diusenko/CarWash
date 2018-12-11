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
    
    deinit {
        
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
//        self.washers.value.forEach { washer in
//            washer.add(observer: self)
//        }
//        self.accountant.add(observer: self)
//        self.director.add(observer: self)
        
        self.washers.value.forEach { washer in
            washer.observer { [weak self] in
                switch $0 {
                case .available: self?.cars.dequeue().do(washer.performWork)
                case .waitForProcessing: self?.accountant.performWork(processedObject: washer)
                case .busy: return
                }
            }
        }
        
        self.accountant.observer { //[weak self] in
            switch $0 {
            case .available: return
            case .waitForProcessing: self.director.performWork(processedObject: self.accountant)
            case .busy: return
            }
        }

//        self.washers.value.map { washer in
//            washer.observer { [weak washer, weak self] in
//                switch $0 {
//                case .available: self?.cars.dequeue().apply(washer?.performWork)
//                case .waitForProcessing: washer.do(self?.accountant.performWork)
//                case .busy: return
//                }
//            }
//        }
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
}
