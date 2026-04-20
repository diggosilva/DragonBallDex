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
    func getChars() -> [Char]
    func search(text: String)
    
    var isSearching: Bool { get }
}

@MainActor
final class FeedViewModel: FeedViewModelProtocol {
    
    private var chars: [Char] = []
    
    private var filteredChars: [Char] = []
    private var currentSearchText: String = ""
    
    private var currentPage = 1
    private var totalPages: Int?
    private var isFetching: Bool = false
    
    var isSearching: Bool {
        return !currentSearchText.isEmpty
    }
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    @Published private var state: FeedVCState = .idle
    
    var statePublisher: AnyPublisher<FeedVCState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    func numberOfItems() -> Int {
        return filteredChars.count
    }
    
    func charForItem(at index: Int) -> Char {
        return filteredChars[index]
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
                self.filteredChars = chars
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
    
    func getChars() -> [Char] {
        return filteredChars
    }
    
    func search(text: String) {
        let normalized = normalize(text)
        
        guard currentSearchText != normalized else { return }
        
        currentSearchText = normalized
        applyFilter()
        
        state = .loaded
    }
    
    private func normalize(_ text: String) -> String {
        return text
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
            .lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func applyFilter() {
        if currentSearchText.isEmpty {
            filteredChars = chars
        } else {
            filteredChars = chars.filter {
                normalize($0.name).contains(currentSearchText) ||
                normalize($0.race).contains(currentSearchText)
            }
        }
    }
}
