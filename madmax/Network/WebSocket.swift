//
//  SocketManager.swift
//  madmax
//
//  Created by jerry A on 10/4/24.
//

import Foundation

class WebSocket: NSObject {
    private var connectCompletion: ((_ isSuccess: Bool) -> Void)?
    private var socketErrorHandler: ((WebSocketError) -> ())?
    private let url: URL
    private var webSocketTask: URLSessionWebSocketTask?
    private var timer: Timer?

    init(url: URL) {
        self.url = url
    }

    func openWebSocket(
        completion: ((Bool) -> Void)?,
        socketErrorHandler: ((WebSocketError) -> ())?
    ) {
        self.connectCompletion = completion
        self.socketErrorHandler = socketErrorHandler

        webSocketTask?.cancel(with: .goingAway, reason: nil)

        let urlSession = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: OperationQueue()
        )
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()

        startPing()
    }

    func closeWebSocket() {
        self.webSocketTask = nil
        self.timer?.invalidate()
    }

    private func startPing() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(
            withTimeInterval: 10,
            repeats: true,
            block: { [weak self] _ in
                self?.ping()
            }
        )
    }

    private func ping() {
        self.webSocketTask?.sendPing(pongReceiveHandler: { [weak self] _ in
            self?.socketErrorHandler?(.disconnected)
        })
    }

    func send(message: String, errorHandler: ((Error) -> Void)?) {
        let taskMessage = URLSessionWebSocketTask.Message.string(message)
        self.webSocketTask?.send(taskMessage, completionHandler: { error in
            guard let error else { return }
            errorHandler?(error)
        })
    }

    func receive() async throws -> URLSessionWebSocketTask.Message? {
        return try await webSocketTask?.receive()
    }
}

extension WebSocket: URLSessionWebSocketDelegate {
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        connectCompletion?(true)
        connectCompletion = nil
    }

    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        connectCompletion?(false)
        connectCompletion = nil
    }
}

/*
 {
   "table": "orderBookL2_25",
   "action": "partial",
   "keys": [
     "symbol",
     "id",
     "side"
   ],
   "types": {
     "symbol": "symbol",
     "id": "long",
     "side": "symbol",
     "size": "long",
     "price": "float",
     "timestamp": "timestamp",
     "transactTime": "timestamp"
   },
   "filter": {
     "symbol": "XBTUSD"
   },
   "data": [
     {
       "symbol": "XBTUSD",
       "id": 52814878186,
       "side": "Sell",
       "size": 10400,
       "price": 60639.2,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:34.545Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815006532,
       "side": "Sell",
       "size": 11900,
       "price": 60638.4,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.830Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814531055,
       "side": "Sell",
       "size": 26500,
       "price": 60636.7,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:15:08.016Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814867939,
       "side": "Sell",
       "size": 8100,
       "price": 60636.6,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:40.565Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007121,
       "side": "Sell",
       "size": 50000,
       "price": 60635.2,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.875Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814858889,
       "side": "Sell",
       "size": 150000,
       "price": 60634.5,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:00.130Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814635066,
       "side": "Sell",
       "size": 12700,
       "price": 60634.1,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:45.012Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815006565,
       "side": "Sell",
       "size": 5000,
       "price": 60634.0,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.833Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007494,
       "side": "Sell",
       "size": 30900,
       "price": 60633.4,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.913Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814911285,
       "side": "Sell",
       "size": 52600,
       "price": 60633.3,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:32.844Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814601690,
       "side": "Sell",
       "size": 300,
       "price": 60633.0,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:14:53.201Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814881486,
       "side": "Sell",
       "size": 1600,
       "price": 60632.7,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:41.050Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814581775,
       "side": "Sell",
       "size": 26500,
       "price": 60631.8,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:32.673Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815004721,
       "side": "Sell",
       "size": 9100,
       "price": 60630.1,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.839Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007264,
       "side": "Sell",
       "size": 26500,
       "price": 60628.1,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.886Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007618,
       "side": "Sell",
       "size": 1200,
       "price": 60624.8,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.927Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007597,
       "side": "Sell",
       "size": 1200,
       "price": 60624.7,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.924Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814880116,
       "side": "Sell",
       "size": 1600,
       "price": 60624.2,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:09.340Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815005353,
       "side": "Sell",
       "size": 100,
       "price": 60623.9,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.733Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814722265,
       "side": "Sell",
       "size": 10500,
       "price": 60623.4,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.880Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814603415,
       "side": "Sell",
       "size": 300,
       "price": 60622.0,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.673Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814992174,
       "side": "Sell",
       "size": 5000,
       "price": 60620.3,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:44.402Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007250,
       "side": "Sell",
       "size": 500,
       "price": 60620.2,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.885Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814932678,
       "side": "Sell",
       "size": 12100,
       "price": 60615.9,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:26.148Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814878482,
       "side": "Sell",
       "size": 1600,
       "price": 60615.7,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.792Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007441,
       "side": "Buy",
       "size": 107400,
       "price": 60615.6,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.947Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007699,
       "side": "Buy",
       "size": 500,
       "price": 60614.2,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.940Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007411,
       "side": "Buy",
       "size": 16500,
       "price": 60614.1,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.904Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007207,
       "side": "Buy",
       "size": 26500,
       "price": 60614.0,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.884Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007150,
       "side": "Buy",
       "size": 26500,
       "price": 60613.9,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.877Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815006144,
       "side": "Buy",
       "size": 500,
       "price": 60610.9,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.928Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007727,
       "side": "Buy",
       "size": 8800,
       "price": 60610.3,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.945Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815005999,
       "side": "Buy",
       "size": 26500,
       "price": 60610.2,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.881Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007109,
       "side": "Buy",
       "size": 16400,
       "price": 60607.1,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.875Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815006088,
       "side": "Buy",
       "size": 8300,
       "price": 60605.0,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.805Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815004795,
       "side": "Buy",
       "size": 26500,
       "price": 60604.8,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.790Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815004743,
       "side": "Buy",
       "size": 8100,
       "price": 60601.8,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.877Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815004666,
       "side": "Buy",
       "size": 26500,
       "price": 60601.7,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.702Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815004490,
       "side": "Buy",
       "size": 14300,
       "price": 60597.0,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.780Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814995306,
       "side": "Buy",
       "size": 28500,
       "price": 60596.9,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.916Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52814993844,
       "side": "Buy",
       "size": 800,
       "price": 60596.5,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:45.046Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815004622,
       "side": "Buy",
       "size": 16400,
       "price": 60596.1,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.676Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007665,
       "side": "Buy",
       "size": 6000,
       "price": 60594.5,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.933Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815001667,
       "side": "Buy",
       "size": 8500,
       "price": 60593.9,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:49.223Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815001659,
       "side": "Buy",
       "size": 26500,
       "price": 60593.8,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:49.219Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815007142,
       "side": "Buy",
       "size": 13200,
       "price": 60592.3,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.876Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815006541,
       "side": "Buy",
       "size": 100,
       "price": 60591.5,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.831Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815006717,
       "side": "Buy",
       "size": 5200,
       "price": 60590.7,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.844Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815003079,
       "side": "Buy",
       "size": 1200,
       "price": 60590.6,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.162Z"
     },
     {
       "symbol": "XBTUSD",
       "id": 52815003331,
       "side": "Buy",
       "size": 1200,
       "price": 60590.5,
       "timestamp": "2024-10-03T16:16:50.982Z",
       "transactTime": "2024-10-03T16:16:50.287Z"
     }
   ]
 }
 */
