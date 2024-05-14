//
//  SecondDetailViewModel.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 11.05.2024.
//

import Foundation

class SecondDetailViewModel {
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
        
        let minValue = String(format: "%.2f", intGraph.min() ?? 0.0)
        let maxValue = String(format: "%.2f", intGraph.max() ?? 0.0)
        
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
               lastPrice = String(format: "$%.2f", change)
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
        if let coinPrice = coin.price {
            formatPrice = String(format: "%.2f", Double(coinPrice)!)
        } 
        return formatPrice
    }
}
