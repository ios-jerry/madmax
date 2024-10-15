//
//  OrderBookUseCase.swift
//  madmax
//
//  Created by jerry A on 10/4/24.
//

import Combine
import Foundation

class OrderBookUseCase {
    let repository: OrderBookRepository
    @Published var buyItems: [OrderBook.Datum] = []
    @Published var sellItems: [OrderBook.Datum] = []
    private let maxItemCount: Int = 20

    init(repository: OrderBookRepository) {
        self.repository = repository
    }

    func openWebSocket(socketErrorHandler: ((WebSocketError) -> ())?) {
        repository.openWebSocket(
            completion: { [weak self] isSuccess in
                if isSuccess {
                    self?.receiveUntilGetPartial()
                } else {
                    socketErrorHandler?(.disconnected)
                }
            },
            socketErrorHandler: { error in
                socketErrorHandler?(error)
            }
        )
    }

    func closeWebSocket() {
        repository.closeWebSocket()
    }

    private func receiveUntilGetPartial() {
        Task {
            do {
                let orderBook = try await repository.receive()

                if let orderBook,
                   orderBook.action == .partial {
                    setOrderBook(orderBook)
                    receiveNextItem()
                } else {
                    receiveUntilGetPartial()
                }
            } catch {
                print(error)
            }
        }
    }

    private func receiveNextItem() {
        Task {
            do {
                defer {
                    receiveNextItem()
                }
                
                guard let orderBook = try await repository.receive() else { return }

                switch orderBook.action {
                case .delete:
                    deleteItems(orderBook)
                case .insert:
                    insertItems(orderBook)
                case .update:
                    updateItems(orderBook)
                default:
                    break
                }

                //jerry TODO: remove
                try? await Task.sleep(nanoseconds: 500_000_000)
            } catch {
                print(error)
            }
        }
    }
    
    private func setOrderBook(_ orderBook: OrderBook) {
        buyItems = []
        sellItems = []

        insertItems(orderBook)
    }

    private func deleteItems(_ orderBook: OrderBook) {
        for data in orderBook.data {
            if data.side == .buy {
                buyItems.removeAll { $0 == data }
            } else {
                sellItems.removeAll { $0 == data }
            }
        }
    }

    private func insertItems(_ orderBook: OrderBook) {
        for data in orderBook.data {
            if data.side == .buy {
                if buyItems.count < maxItemCount {
                    buyItems.append(data)
                }
            } else {
                if sellItems.count < maxItemCount {
                    sellItems.append(data)
                }
            }
        }

        buyItems.sort { $0.price > $1.price }
        sellItems.sort { $0.price < $1.price }
    }

    private func updateItems(_ orderBook: OrderBook) {
        for data in orderBook.data {
            if data.side == .buy {
                if let firstIndex = buyItems.firstIndex(where: { $0 == data }) {
                    buyItems[firstIndex] = data
                }
            } else {
                if let firstIndex = sellItems.firstIndex(where: { $0 == data }) {
                    sellItems[firstIndex] = data
                }
            }
        }
    }
}
