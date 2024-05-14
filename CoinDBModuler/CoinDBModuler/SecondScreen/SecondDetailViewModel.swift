//
//  SecondDetailViewModel.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 11.05.2024.
//

import Foundation

final class SecondDetailViewModel {
    var coin: CoinIcons?
    var graphInfo: [String]?
    
    // Function to configure view model with data
    func configure(with coin: CoinIcons, graphInfo: [String]) {
        self.coin = coin
        self.graphInfo = graphInfo
    }
    
    func lowHighDedict() -> (minValue: String?, maxValue: String?){
        guard let graphInfo = graphInfo else {
            print("No graph info available")
            return (nil, nil)
        }
        let intGraph = graphInfo.compactMap { Double($0) }
        
        let minValue = intGraph.min()?.formattedStringWithThreeDecimal()
        let maxValue = intGraph.max()?.formattedStringWithThreeDecimal()
        
        return (minValue, maxValue)
        
    }
    
    func rankChangeCalculate() -> String? {
        guard let coin = coin else {
            print("No graph info available")
            return nil
        }
        var lastPrice = ""
        if let coinPrice = coin.price {
            if let coinPriceDouble = Double(coinPrice), let changeRateDouble = Double(coin.changeRate ?? "0.0") {
                let change = coinPriceDouble * changeRateDouble / 100.0
                lastPrice = change.formattedString()
            }
           
        }
        return lastPrice
    }
    func priceTextFormat() -> String? {
        guard let coin = coin else {
            print("No graph info available")
            return nil
        }
        var formatPrice = ""
        if let coinPrice = Double(coin.price!) {
            formatPrice = coinPrice.formattedString()
        }
        return formatPrice
    }
}
