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
    
    private let weakWashersManagerObservers = Atomic([StaffManager<Washer, Car>.Observer]())
    private let weakAccountantsManagerObservers = Atomic([StaffManager<Accountant, Washer>.Observer]())
    
    private let washerManager: StaffManager<Washer, Car>
    private let accountManager: StaffManager<Accountant, Washer>
    private let directorManager: StaffManager<Director, Accountant>
    
    init(
        id: Int,
        accountant: [Accountant],
        director: [Director],
        washers: [Washer]
    ) {
        self.id = id
        self.washerManager = StaffManager(objects: washers)
        self.accountManager = StaffManager(objects: accountant)
        self.directorManager = StaffManager(objects: director)
        self.attach()
    }
    
    func washCar(_ car: Car) {
        self.washerManager.performWork(processedObject: car)
    }
    
    private func attach() {
        let weakWasher = self.washerManager.observer(handler: self.accountManager.performWork)
        let weakAccountant = self.accountManager.observer(handler: self.directorManager.performWork)
        
        self.weakWashersManagerObservers.modify {
            $0.append(weakWasher)
        }
        self.weakAccountantsManagerObservers.modify {
            $0.append(weakAccountant)
        }
   }
}
