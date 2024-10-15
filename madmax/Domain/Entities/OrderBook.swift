//
//  OrderBook.swift
//  madmax
//
//  Created by jerry A on 10/4/24.
//

import Foundation

struct OrderBook {
    let action: Action
    let data: [Datum]
}

extension OrderBook {
    enum Action: String {
        case partial
        case update
        case delete
        case insert
    }

    struct Datum {
        let id: Int
        let side: Side
        let size: Int?
        let price: Double
        let transactTime: String
    }

    enum Side: String {
        case buy = "Buy"
        case sell = "Sell"
    }
}

extension OrderBook.Datum: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: OrderBook.Datum, rhs: OrderBook.Datum) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
