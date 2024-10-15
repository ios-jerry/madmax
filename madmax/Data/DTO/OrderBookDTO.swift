//
//  OrderBookDTO.swift
//  madmax
//
//  Created by jerry A on 10/4/24.
//

import Foundation

struct OrderBookDTO: Codable {
    let action: Action
    let data: [Datum]
}

extension OrderBookDTO {
    enum Action: String, Codable {
        case partial
        case update
        case delete
        case insert
    }

    struct Datum: Codable {
        let id: Int
        let side: Side
        let size: Int?
        let price: Double
        let transactTime: String
    }

    enum Side: String, Codable {
        case buy = "Buy"
        case sell = "Sell"
    }
}

extension OrderBookDTO {
    var toDomain: OrderBook? {
        guard let action = OrderBook.Action(rawValue: action.rawValue)
        else {
            print("yang action is nil :\(action.rawValue)")
            return nil
        }

        return OrderBook(
            action: action,
            data: data.map {
                OrderBook.Datum(
                    id: $0.id,
                    side: .init(rawValue: $0.side.rawValue)!,
                    size: $0.size,
                    price: $0.price,
                    transactTime: $0.transactTime
                )
            }
        )
    }
}
