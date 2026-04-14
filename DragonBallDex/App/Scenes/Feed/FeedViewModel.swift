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
    func numberOfItems() -> Int
    func charForItem(at index: Int) -> Char
    func getCharacters()
}

@MainActor
final class FeedViewModel: FeedViewModelProtocol {
    
    private var chars: [Char] = []
    private var currentPage = 1
    private var totalPages: Int?
    private var isFetching: Bool = false
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    @Published private var state: FeedVCState = .idle
    
    var statePublisher: AnyPublisher<FeedVCState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    func numberOfItems() -> Int {
        return chars.count
    }
    
    func charForItem(at index: Int) -> Char {
        return chars[index]
    }
    
    func getCharacters() {
        // 1. Evita chamadas se já estiver carregando ou se já chegou no fim
        guard !isFetching else { return }
        if let total = totalPages, currentPage > total { return }
        
        isFetching = true
        
        Task {
            do {
                if currentPage == 1 { state = .loading }
                
                // 2. Passa a página atual para o Service
                let response = try await service.getCharacters(page: currentPage)
                
                // 3. Acumula os personagens em vez de substituir
                let newChars = response.items.map({ $0.toDomain() })
                self.chars.append(contentsOf: newChars)
                self.totalPages = response.meta.totalPages
                self.currentPage += 1
                
                state = .loaded
                isFetching = false
            } catch {
                print("Erro ao carregar os dados: \(error.localizedDescription)")
                state = .error
                isFetching = false
            }
        }
    }
}
