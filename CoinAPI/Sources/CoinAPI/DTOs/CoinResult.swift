//
// CoinResult.swift
//
//
//  Created by Ece Ok, Vodafone on 8.05.2024.
//

import Foundation
public struct Coin: Decodable {
    public let uuid: String?
    public let symbol: String?
    public let name: String?
    public let color: String?
    public let iconUrl: URL?
    public let marketCap: String?
    public let price: String?
    public let listedAt: Int?
    public let tier: Int?
    public let change: String?
    public let rank: Int?
    public let sparkline: [String]?
    public let lowVolume: Bool?
    public let coinrankingUrl: URL?
    public let volume24h: String?
    public let btcPrice: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color, iconUrl, marketCap, price, listedAt, tier, change, rank, sparkline, lowVolume, coinrankingUrl
        case volume24h = "24hVolume"
        case btcPrice = "btcPrice"
    }
}

public struct CoinsResponse: Decodable {
    public let status: String
    public let datas: CoinsData
    
    enum CodingKeys: String, CodingKey {
        case status
        case datas = "data"
    }
}

public struct CoinsData: Decodable {
    public let stats: Stats
    public let coins: [Coin]
}

public struct Stats: Decodable {
    public let total: Int
    public let totalCoins: Int
    public let totalMarkets: Int
    public let totalExchanges: Int
    public let totalMarketCap: String
    public let total24hVolume: String
}
