//
//  SocketManager.swift
//  BitCoinTracker
//
//  Created by Pavel Senchenko on 02.02.2021.
//

import Foundation
import Starscream

//MARK: - Protocol
// Interface
protocol SocketManager {
    var responseDelegate: SocketManagerDelegate? { get set }
    init()
    func on()
    func of()
    func send(message: String)
}
// Delegate
protocol SocketManagerDelegate: class {
    func didReceiveResponse(object: SocketResponseObject)
}

//MARK: - Base Class
class Socket {
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    let urlString = NetworkProperties().urlString
    
    public weak var responseDelegate: SocketManagerDelegate?
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        decoder.dataDecodingStrategy = .base64
        return decoder
    }
    
    required init() {
        var request = URLRequest(url: URL(string: urlString)!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }
}
//MARK: - Interface Implementation
extension Socket: SocketManager {
    func on() {
        print(#function)
        socket.connect()
    }
    func of() {
        print(#function)
        socket.disconnect()
    }
    func send(message: String) {
        print(#function)
        socket.write(string: message)
    }
}

// MARK: - WebSocketDelegate
// handle messages
extension Socket: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            parseText(string)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    func parseText(_ string: String) {
        let data = Data(string.utf8)
        if let object = try? decoder.decode(SocketResponseObject.self, from: data) {
            responseDelegate?.didReceiveResponse(object: object)
        } else {
            fatalError()
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}
