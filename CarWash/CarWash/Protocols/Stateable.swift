//
//  Stateable.swift
//  CarWash
//
//  Created by Student on 11/7/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

protocol Stateable: class {
    
    var state: Person.State { get set }
}
