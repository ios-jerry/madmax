//
//  ContentView.swift
//  madmax
//
//  Created by Taeheon Woo on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: OrderBookViewModel
    
    var body: some View {
        VStack {
            Button {
                viewModel.openWebSocket()
            } label: {
                Text("Open WebSocket")
            }
            Spacer().frame(height: 50)
            Button {
                viewModel.closeWebSocket()
            } label: {
                Text("Close WebSocket")
            }
        }
        .onAppear {

        }
        .onDisappear {
            viewModel.closeWebSocket()
        }
    }
}

#Preview {
    ContentView(
        viewModel: OrderBookViewModel(
            useCase: OrderBookUseCase(repository: TestOrderBookRepository())
        )
    )
}
