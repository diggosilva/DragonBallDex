//
//  DetailsViewModel.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 15/04/26.
//

import Foundation

protocol DetailsViewModelProtocol {
    var char: Char { get }
    var onDataUpdate: ((Char) -> Void)? { get set }
    
    func fetchDetails()
}

final class DetailsViewModel: DetailsViewModelProtocol {
    
    private(set) var char: Char
    var onDataUpdate: ((Char) -> Void)?
    private let service: ServiceProtocol
    
    init(char: Char, service: ServiceProtocol = Service()) {
        self.char = char
        self.service = service
    }
    
    func fetchDetails() {
        Task {
            do {
                let fullChar = try await service.getCharacterDetails(id: char.id)
                self.char = fullChar
                DispatchQueue.main.async {
                    self.onDataUpdate?(fullChar)
                }
            } catch {
                print("Erro ao carregar transformações: \(error.localizedDescription)")
            }
        }
    }
}
