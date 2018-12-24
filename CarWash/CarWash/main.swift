//
//  main.swift
//  CarWash
//
//  Created by Student on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

let a = Atomic(0, willSet: { print($0.new) })

test()
