//
//  Cancellable.swift
//  CarWash
//
//  Created by Usenko Dmitry on 12/24/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

protocol Cancellable {
    
    var isCancelled: Bool { get }
    
    func cancel()
}
