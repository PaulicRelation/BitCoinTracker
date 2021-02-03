//
//  SubscribedObject.swift
//  BitCoinTracker
//
//  Created by Pavel Senchenko on 02.02.2021.
//

import Foundation

struct SubscribedObject : Equatable {
    let currency: Currency
    let exchanger: Exchanger
    let subscribe: String
    let unsubscribe: String
    var lastPrice: Double?
    let lastDirection: Direction?
   
    init(_ exchanger: Exchanger, _ currensy: Currency) {
        self.currency = currensy
        self.exchanger = exchanger
        self.subscribe = "{\"subscribe\":\"trade.btc_\(currency)_\(exchanger)\"}"
        self.unsubscribe = "{\"unsubscribe\":\"trade.btc_\(currency)_\(exchanger)\"}"
        self.lastPrice = 0
        self.lastDirection = nil
    }
    
    enum Direction {
        case up, down
    }
    
    static func ==(lhs: SubscribedObject, rhs: SubscribedObject) -> Bool {
        return lhs.exchanger == rhs.exchanger && lhs.currency == rhs.currency
    }
    
}
