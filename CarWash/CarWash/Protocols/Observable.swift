//
//  Observable.swift
//  CarWash
//
//  Created by Student on 12/6/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

protocol Observable: class {
    
    associatedtype ProcessObject: MoneyGiver
    
    func add(observer: StateObserver)
    
    func remove(observer: StateObserver)
    
    func notify(oldValue: Staff<ProcessObject>.State, newValue: Staff<ProcessObject>.State)
}
