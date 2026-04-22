//
//  DetailsViewModel.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 15/04/26.
//

import Foundation
import Combine

enum DetailsVCStates {
    case idle
    case loading
    case loaded
    case error
}

protocol DetailsViewModelProtocol: StatefulViewModel where State == DetailsVCStates {
    var char: Char { get }
    
    func fetchDetails()
}

@MainActor
final class DetailsViewModel: DetailsViewModelProtocol {
    
    @Published private(set) var char: Char
    @Published private var state: DetailsVCStates = .idle
    
    var statePublisher: AnyPublisher<DetailsVCStates, Never> {
        $state.eraseToAnyPublisher()
    }
    
    private let service: ServiceProtocol
    
    init(char: Char, service: ServiceProtocol) {
        self.char = char
        self.service = service
    }
    
    func fetchDetails() {
        state = .loading
        
        Task {
            do {
                let fullChar = try await service.getCharacterDetails(id: char.id)
                self.char = fullChar
                state = .loaded
            } catch {
                print("Erro ao carregar transformações: \(error.localizedDescription)")
                state = .error
            }
        }
    }
}
