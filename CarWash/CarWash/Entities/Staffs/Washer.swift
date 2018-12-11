//
//  Washer.swift
//  CarWash
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class Washer: Employee<Car> {

    override func performProcessing(object car: Car) {
        car.atomicState.modify { $0 = .clean }
    }
    
    override func completeProcessing(object car: Car) {
        self.receiveMoney(from: car)
        print(
            self,
            "wash", "Car",
            "and get", "\(self.money)$"
        )
    }
}
