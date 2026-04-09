//
//  Service.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 08/04/26.
//

import Foundation

protocol ServiceProtocol {
    func getCharacters() async throws -> [Char]
}

final class Service: ServiceProtocol {
    
    let baseURL = "https://dragonball-api.com/api"
    
    func getCharacters() async throws -> [Char] {
        guard let url = URL(string: "\(baseURL)/characters") else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        
        let charResponse = try JSONDecoder().decode(CharResponse.self, from: data)
        
        return charResponse.items.map({ $0.toDomain() })
    }
}
