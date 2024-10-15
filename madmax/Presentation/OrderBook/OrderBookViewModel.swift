//
//  OrderBookViewModel.swift
//  madmax
//
//  Created by jerry A on 10/4/24.
//

import Combine
import Foundation

class OrderBookViewModel: ObservableObject {
    let useCase: OrderBookUseCase
    var isSockeError = false
    @Published var buyItems: [OrderBook.Datum] = []
    @Published var sellItems: [OrderBook.Datum] = []

    private var bag = Set<AnyCancellable>()

    init(useCase: OrderBookUseCase) {
        self.useCase = useCase
        //jerry TODO: change to asign
        useCase.$buyItems.sink { [weak self] items in
            print("buyItems:\(items)")
            self?.buyItems = items
        }.store(in: &bag)

        useCase.$sellItems.sink { [weak self] items in
            print("sellItems:\(items)")
            self?.sellItems = items
        }.store(in: &bag)
    }

    func openWebSocket() {
        useCase.openWebSocket { [weak self] error in
            self?.isSockeError = true
        }
    }

    func closeWebSocket() {
        useCase.closeWebSocket()
    }
}
