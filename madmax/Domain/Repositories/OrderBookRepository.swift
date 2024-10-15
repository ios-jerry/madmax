//
//  OrderBookRepository.swift
//  madmax
//
//  Created by jerry A on 10/4/24.
//

import Foundation

protocol OrderBookRepository {
    func openWebSocket(
        completion: ((Bool) -> Void)?,
        socketErrorHandler: ((WebSocketError) -> ())?
    )
    func closeWebSocket()
    func receive() async throws -> OrderBook?
}
