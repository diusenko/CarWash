//
//  main.swift
//  CarWash
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

var washers = [Washer]()

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

var factory = CarFactory(washService: washService, interval: 5.0)
factory.start()
sleep(22)
factory.cancel()

RunLoop.current.run()
