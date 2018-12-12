//
//  test.swift
//  CarWash
//
//  Created by Student on 12/12/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

func test() {
    var washers = [Washer]()
    let testDuration: UInt32 = 22
    
    (0..<4)
        .map { id in Washer(id: id) }
        .forEach {
            washers.append($0)
    }
    
    let director = Director(id: 1)
    let accountant = Accountant(id: 1)
    
    let washService = WashService(
        id: 1,
        accountant: accountant,
        director: director,
        washers: washers
    )
    
    let factory = CarFactory(washService: washService, interval: 5.0)
    factory.start()
    sleep(testDuration)
    factory.cancel()
    
    RunLoop.current.run()
}
