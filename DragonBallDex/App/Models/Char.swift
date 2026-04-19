//
//  Char.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 08/04/26.
//

import Foundation

struct Char: Codable, Hashable {
    let id: Int
    let name: String
    let ki: String
    let maxKi: String
    let race: String
    let gender: String
    let description: String
    let image: String
    let affiliation: String
    let transformations: [Transformation]
    
    struct Transformation: Codable, Hashable {
        let id: Int
        let name: String
        let image: String
        let ki: String
        
        var formattedKi: String {
            let cleanKi = ki.replacingOccurrences(of: ".", with: "")
            guard let value = Double(cleanKi) else { return ki }
            return value.abbreviated
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Char, rhs: Char) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.ki == rhs.ki
    }
}

extension Char {
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
