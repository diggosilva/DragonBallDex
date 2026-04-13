//
//  Double+Extensions.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 12/04/26.
//

import Foundation

extension Double {
    
    private var billion: Double { 1_000_000_000 }
    private var million: Double { 1_000_000 }
    private var thousand: Double { 1_000 }
    
    var abbreviated: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        formatter.roundingMode = .halfUp
        
        if self >= billion {
            return format(value: self / billion, unit: "B", with: formatter)
        } else if self >= million {
            return format(value: self / million, unit: "M", with: formatter)
        } else if self >= thousand {
            return format(value: self / thousand, unit: "K", with: formatter)
        }
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    private func format(value: Double, unit: String, with formatter: NumberFormatter) -> String {
        let numberString = formatter.string(from: NSNumber(value: value)) ?? ""
        return "\(numberString)\(unit)"
    }
}
