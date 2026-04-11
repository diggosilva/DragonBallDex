//
//  StatefulViewModel.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 09/04/26.
//

import Combine

protocol StatefulViewModel {
    associatedtype State
    var statePublisher: AnyPublisher<State, Never> { get }
}
