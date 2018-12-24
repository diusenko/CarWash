//
//  DispatchQueue+Extensions.swift
//  CarWash
//
//  Created by Usenko Dmitry on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static var background: DispatchQueue {
        return .global(qos: .background)
    }
    
    func timer(
        interval: TimeInterval,
        execute: @escaping F.VoidExecute
    )
        -> CancellationToken
    {
        let cancellationToken = CancellationToken()
        
        self.startTimer(interval: interval,
            cancellationToken: cancellationToken,
            execute: execute
        )
        
        return cancellationToken
    }
    
    private func startTimer(
        interval: TimeInterval,
        cancellationToken: CancellationToken,
        execute: @escaping F.VoidExecute
    ) {
        self.asyncAfter(deadline: .after(interval: interval)) {
            if !cancellationToken.isCancelled {
                execute()
                self.startTimer(
                    interval: interval,
                    cancellationToken: cancellationToken,
                    execute: execute
                )
            }
        }
    }
    
    class CancellationToken: Cancellable {
        
        var isCancelled: Bool {
            return !self.tokenState.value
        }
        
        private let tokenState = Atomic(true)
        
        func cancel() {
            tokenState.value = false
        }
    }
}
