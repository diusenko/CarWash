//
//  MoneyReceiver.swift
//  CarWash
//
//  Created by Usenko Dmitry on 10/25/18.
//  Copyright © 2018 Student. All rights reserved.
//

import Foundation

protocol MoneyReceiver {
    
    func receive(money: Int)
}

extension MoneyReceiver {

    func receiveMoney(from moneyGiver: MoneyGiver) {
        self.receive(money: moneyGiver.giveMoney())
    }
}
