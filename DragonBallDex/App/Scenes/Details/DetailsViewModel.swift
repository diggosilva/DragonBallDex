//
//  DetailsViewModel.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 15/04/26.
//

import Foundation

protocol DetailsViewModelProtocol {
    var char: Char { get }
}

final class DetailsViewModel: DetailsViewModelProtocol {
    
    let char: Char
    
    init(char: Char) {
        self.char = char
    }
}
