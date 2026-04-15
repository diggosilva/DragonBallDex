//
//  Char.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 08/04/26.
//

import Foundation

struct Char: Codable {
    let id: Int
    let name: String
    let ki: String
    let maxKi: String
    let race: String
    let gender: String
    let description: String
    let image: String
    let affiliation: String
    
    var formattedKi: String {
        let cleanKi = ki.replacingOccurrences(of: ".", with: "")
        guard let value = Double(cleanKi) else { return "Ki: \(ki)" }
        return "Ki: \(value.abbreviated)"
    }
    
    var formattedKiDetails: String {
        let cleanKi = ki.replacingOccurrences(of: ".", with: "")
        guard let value = Double(cleanKi) else { return ki }
        return "\(value.abbreviated)"
    }
    
    var formattedMaxKiDetails: String {
        let cleanKi = maxKi.replacingOccurrences(of: ".", with: "")
        guard let value = Double(cleanKi) else { return maxKi }
        return "\(value.abbreviated)"
    }
}
