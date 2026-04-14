//
//  DragonBallEndpoint.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 13/04/26.
//

import Foundation

enum DragonBallEndpoint {
    case characters(page: Int)
    case details(id: Int)
    
    private var baseURL: String {
        return "https://dragonball-api.com/api"
    }
    
    var url: URL? {
        var components = URLComponents(string: baseURL)
        switch self {
        case .characters(let page):
            components?.path += "/characters"
            components?.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
            
        case .details(let id):
            components?.path += "/characters/\(id)"
        }
        return components?.url
    }
}
