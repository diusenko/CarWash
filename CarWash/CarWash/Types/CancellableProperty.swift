//
//  CancellableProperty.swift
//  CarWash
//
//  Created by Usenko Dmitry on 12/24/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

class AbstractCancelableProperty<Storage> {
    
    var value: Storage {
        get { return self.atomicCancellable.value }
        set { self.atomicCancellable.value = newValue }
    }
    
    let atomicCancellable: Atomic<Storage>
    
    init(initial: Storage, dispose: @escaping (Storage) -> ()) {
        self.atomicCancellable = Atomic(initial, lock: .init()) {
            dispose($0.old)
        }
    }
    
}

class CancellableProperty: AbstractCancelableProperty<Cancellable?> {
    
    init() {
        super.init(initial: nil) {
            $0?.cancel()
        }
    }
}


class CompositeCancellableProperty: AbstractCancelableProperty<[Cancellable]> {
    init() {
        super.init(initial: []) {
            $0.forEach { $0.cancel() }
        }
    }
}
