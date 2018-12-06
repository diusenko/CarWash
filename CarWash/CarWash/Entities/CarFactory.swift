//
//  Factory.swift
//  CarWash
//
//  Created by Student on 11/7/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class CarFactory {
    
    var isCancelled: Bool {
        return self.cancellationToken == nil
    }
    
    private var cancellationToken: DispatchQueue.CancellationToken? {
        willSet { self.cancellationToken?.stop() }
    }

    private let cars = 10
    private let washService: WashService
    private let interval: TimeInterval
    private let queue: DispatchQueue
    
    deinit {
        self.cancel()
    }
    
    init(washService: WashService, interval: TimeInterval, queue: DispatchQueue = .background) {
        self.washService = washService
        self.interval = interval
        self.queue = queue
    }
    
    func start() {
        self.cancellationToken = self.queue
            .timer(interval: self.interval) { [weak self] in
                self?.carsFeed()
            }
    }
    
    func cancel() {
        self.cancellationToken = nil
    }
    
    private func carsFeed() {
        print("New wave")
        self.cars.times {
            self.queue.async {
                self.washService.washCar(Car(money: 10))
            }
        }
    }
}
