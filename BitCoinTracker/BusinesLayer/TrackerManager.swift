//
//  TrackerManager.swift
//  BitCoinTracker
//
//  Created by Pavel Senchenko on 02.02.2021.
//

import Foundation

//MARK: - Protocols
protocol TrackerManager {
    var priceDelegate: PriceDelegate? { get set }
    func startTracking()
    func stopTracking()
    func track(_ exchanger: Exchanger, with currency: Currency)
    func untrack(_ exchanger: Exchanger, with currency: Currency)
}
protocol PriceDelegate: class {
    func haveNewPrice(price: Double)
}

//MARK: - Implimentation
final class Tracker: TrackerManager {
    var network: SocketManager = Socket()
    weak var priceDelegate: PriceDelegate?
    
    internal init(delegate: PriceDelegate? = nil) {
        self.priceDelegate = delegate
        self.network.responseDelegate = self
    }
    func startTracking() {
        network.on()
    }
    func stopTracking() {
        network.of()
    }
    func track(_ exchanger: Exchanger, with currency: Currency) {
        let messageObject = SubscribedObject.init(exchanger, currency)
        network.send(message: messageObject.subscribe)
    }
    func untrack(_ exchanger: Exchanger, with currency: Currency) {
        let messageObject = SubscribedObject.init(exchanger, currency)
        network.send(message: messageObject.unsubscribe)
    }
}

//MARK: - SocketMeneger Delegate Implimentation
extension Tracker: SocketManagerDelegate {
    func didReceiveResponse(object: SocketResponseObject) {
        priceDelegate?.haveNewPrice(price: object.price)
    }
}
