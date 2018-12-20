//
//  Processable.swift
//  CarWash
//
//  Created by Student on 12/20/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

protocol Processable {
    
    associatedtype ProcessedObject
    
    func processObject(processedObject: ProcessedObject)
}
