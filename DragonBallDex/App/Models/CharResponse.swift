//
//  CharResponse.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 08/04/26.
//

import Foundation

struct CharResponse: Codable {
    var items: [Item]
}

struct Item: Codable {
    let id: Int
    let name: String
    let ki: String
    let maxKi: String
    let race: String
    let gender: String
    let description: String
    let image: String
    let affiliation: String
}

extension Item {
    func toDomain() -> Char {
        return Char(
            id: id,
            name: name,
            ki: ki,
            maxKi: maxKi,
            race: race,
            gender: gender,
            description: description,
            image: image,
            affiliation: affiliation
        )
    }
}
