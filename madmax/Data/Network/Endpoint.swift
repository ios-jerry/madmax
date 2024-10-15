//
//  Endpoint.swift
//  madmax
//
//  Created by jerry A on 10/4/24.
//

import Foundation

enum Endpoint: String {
    case orderBook = "wss://ws.bitmex.com/realtime?subscribe=orderBookL2:XBTUSD"
    case trade = "wss://ws.bitmex.com/realtime?subscribe=trade:XBTUSD"
}
