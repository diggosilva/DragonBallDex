//
//  FeedViewModel.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 09/04/26.
//

import Foundation
import Combine

enum FeedVCState {
    case idle
    case loading
    case loaded
    case error
}

protocol FeedViewModelProtocol: StatefulViewModel where State == FeedVCState {
    func numberOfRows() -> Int
    func charForRow(at index: Int) -> Char
    func getCharacters()
}

@MainActor
final class FeedViewModel: FeedViewModelProtocol {
    
    private var chars: [Char] = []
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    @Published private var state: FeedVCState = .idle
    
    var statePublisher: AnyPublisher<FeedVCState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    func numberOfRows() -> Int {
        return chars.count
    }
    
    func charForRow(at index: Int) -> Char {
        return chars[index]
    }
    
    func getCharacters() {
        Task {
            do {
                state = .loading
                chars = try await service.getCharacters()
                state = .loaded
            } catch {
                print("Erro ao carregar os dados: \(error.localizedDescription)")
                state = .error
            }
        }
    }
}
