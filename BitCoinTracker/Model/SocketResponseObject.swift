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
    let type: BidType? // sometimes resive expected field in bitstamp response
    
    enum BidType: String, Codable {
        case buy = "buy"
        case sell = "sell"
    }
    
    enum CodingKeys: String, CodingKey {
        case time
        case price
        case quantity
        case type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.time = try container.decode(Date.self, forKey: .time)
        do {
            self.price = try container.decode(Double.self, forKey: .price)
        } catch {
            let string = try container.decode(String.self, forKey: .price)
            self.price = (string as NSString).doubleValue
        }
        do {
            self.quantity = try container.decode(Double.self, forKey: .quantity)
        } catch {
            let string = try container.decode(String.self, forKey: .quantity)
            self.quantity = (string as NSString).doubleValue
        }
        self.type = try? container.decode(BidType.self, forKey: .type)
    }
    
}
