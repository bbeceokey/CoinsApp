//
//  Formatter.swift
//  CoinDBModuler
//
//  Created by Ece Ok, Vodafone on 14.05.2024.
//

import Foundation

extension Double {
    func formattedString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        if let formattedString = formatter.string(from: NSNumber(value: self)) {
            return formattedString
        } else {
            return "0.00"
        }
    }
    
    func formattedStringWithThreeDecimal() -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 3
            formatter.maximumFractionDigits = 3
            
            if let formattedString = formatter.string(from: NSNumber(value: self)) {
                return formattedString
            } else {
                return "0.000"
            }
        }
}

extension Int{
    
    func calculateMillion() -> (Int,Int) {
            let milyon = self / 1_000_000
            let bin = (self % 1_000_000) / 1_000
            return (milyon, bin)
        }
    }

