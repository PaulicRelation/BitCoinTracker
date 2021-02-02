//
//  SocketResponseObject.swift
//  BitCoinTracker
//
//  Created by Pavel Senchenko on 02.02.2021.
//

import Foundation

struct SocketResponseObject: Decodable {
    let time: Date
    let price: Double
    let quantity: Double
    let type: BidType
    
    enum BidType: String, Decodable {
        case buy = "buy"
        case sell = "sell"
    }
    
}
