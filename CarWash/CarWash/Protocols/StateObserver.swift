//
//  StateObserver.swift
//  CarWash
//
//  Created by Student on 12/5/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

protocol StateObserver: class {
    
    func valueChanged<T: MoneyGiver>(subject: Staff<T>, newValue: Staff<T>.State)
}
