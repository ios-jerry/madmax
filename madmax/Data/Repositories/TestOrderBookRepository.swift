//
//  TestOrderBookRepository.swift
//  madmax
//
//  Created by jerry A on 10/4/24.
//

import Foundation

class TestOrderBookRepository: OrderBookRepository {
    func openWebSocket(
        completion: ((Bool) -> Void)?,
        socketErrorHandler: ((WebSocketError) -> ())?
    ) {
    }

    func closeWebSocket() {
    }

    func receive() async throws -> OrderBook? {
        OrderBook(
            action: .partial,
            data: [
                .init(id: 1, side: .buy, size: 10, price: 10.1, transactTime: ""),
                .init(id: 2, side: .buy, size: 10, price: 10.2, transactTime: ""),
                .init(id: 3, side: .buy, size: 10, price: 10.3, transactTime: ""),
                .init(id: 4, side: .buy, size: 10, price: 10.4, transactTime: ""),
                .init(id: 5, side: .buy, size: 10, price: 10.5, transactTime: ""),
                .init(id: 6, side: .sell, size: 10, price: 10.1, transactTime: ""),
                .init(id: 7, side: .sell, size: 10, price: 10.2, transactTime: ""),
                .init(id: 8, side: .sell, size: 10, price: 10.3, transactTime: ""),
                .init(id: 9, side: .sell, size: 10, price: 10.4, transactTime: ""),
                .init(id: 10, side: .sell, size: 10, price: 10.5, transactTime: ""),
            ]
        )
    }

    var firstOrderBook: OrderBook {
        OrderBook(
            action: .partial,
            data: [
                .init(id: 1, side: .buy, size: 10, price: 10.1, transactTime: ""),
                .init(id: 2, side: .buy, size: 10, price: 10.2, transactTime: ""),
                .init(id: 3, side: .buy, size: 10, price: 10.3, transactTime: ""),
                .init(id: 4, side: .buy, size: 10, price: 10.4, transactTime: ""),
                .init(id: 5, side: .buy, size: 10, price: 10.5, transactTime: ""),
                .init(id: 6, side: .sell, size: 10, price: 10.1, transactTime: ""),
                .init(id: 7, side: .sell, size: 10, price: 10.2, transactTime: ""),
                .init(id: 8, side: .sell, size: 10, price: 10.3, transactTime: ""),
                .init(id: 9, side: .sell, size: 10, price: 10.4, transactTime: ""),
                .init(id: 10, side: .sell, size: 10, price: 10.5, transactTime: ""),
            ]
        )
    }

    var updateOrderBook: OrderBook {
        OrderBook(
            action: .update,
            data: [
                .init(id: 1, side: .buy, size: 10, price: 9, transactTime: ""),
                .init(id: 9, side: .sell, size: 10, price: 9, transactTime: ""),
            ]
        )
    }

    var deleteOrderBook: OrderBook {
        OrderBook(
            action: .update,
            data: [
                .init(id: 1, side: .buy, size: 10, price: 9, transactTime: ""),
                .init(id: 9, side: .sell, size: 10, price: 9, transactTime: ""),
            ]
        )
    }

    var insertOrderBook: OrderBook {
        OrderBook(
            action: .insert,
            data: [
                .init(id: 1, side: .buy, size: 10, price: 9, transactTime: ""),
                .init(id: 9, side: .sell, size: 10, price: 9, transactTime: ""),
            ]
        )
    }
}
