//
//  DefaultOrderBookRepository.swift
//  madmax
//
//  Created by jerry A on 10/4/24.
//

import Foundation

class DefaultOrderBookRepository: OrderBookRepository {
    let websocket: WebSocket

    init() {
        websocket = WebSocket(url: URL(string: Endpoint.orderBook.rawValue)!)
    }

    func openWebSocket(
        completion: ((Bool) -> Void)?,
        socketErrorHandler: ((WebSocketError) -> ())?
    ) {
        websocket.openWebSocket(completion: completion, socketErrorHandler: socketErrorHandler)
    }

    func closeWebSocket() {
        websocket.closeWebSocket()
    }
    
    func receive() async throws -> OrderBook? {
        let result = try await websocket.receive()
        let message: String?
        switch result {
        case let .string(string):
            message = string
        case let .data(data):
            message = String(data: data, encoding: .utf8)
        default:
            message = nil
        }

        guard let message,
              let data = message.data(using: .utf8)
        else { return nil }

        print("yang message:\(message)\n\n")

        do {
            let orderBookDTO = try JSONDecoder().decode(OrderBookDTO.self, from: data)
            return orderBookDTO.toDomain
        } catch {
            print(error)
            return nil
        }
    }
}
