//
//  SubscribedObject.swift
//  BitCoinTracker
//
//  Created by Pavel Senchenko on 02.02.2021.
//

import Foundation

struct SubscribedObject {
    let currency: Currency
    let exchanger: Exchanger
    let subscribe: String
    let unsubscribe: String
    let lastPrice: Double?
    let lastDirection: Direction?
   
    init(_ exchanger: Exchanger, _ currensy: Currency) {
        self.currency = currensy
        self.exchanger = exchanger
        self.subscribe = "{\"subscribe\":\"trade.btc_\(currency)_\(exchanger)\"}"
        self.unsubscribe = "{\"unsubscribe\":\"trade.btc_\(currency)_\(exchanger)\"}"
        self.lastPrice = nil
        self.lastDirection = nil
    }
    
    enum Direction {
        case up, down
    }
    
}
