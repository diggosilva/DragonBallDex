//
//  ServiceProtocol.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 13/04/26.
//

import Foundation

protocol ServiceProtocol {
    func getCharacters(page: Int) async throws -> CharResponse
}
