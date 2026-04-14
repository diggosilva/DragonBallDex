//
//  Service.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 08/04/26.
//

import Foundation

final class Service: ServiceProtocol {
    
    func getCharacters(page: Int) async throws -> CharResponse {
        guard let url = DragonBallEndpoint.characters(page: page).url else { throw URLError(.badURL) }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        
        let charResponse = try JSONDecoder().decode(CharResponse.self, from: data)
        
        return charResponse
    }
}
