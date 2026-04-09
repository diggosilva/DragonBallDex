//
//  FeedViewController.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 23/03/26.
//

import UIKit

class FeedViewController: UIViewController {

    let service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchData()
    }

    func fetchData() {
        Task {
            let personagens = try await service.getCharacters()
            print("DEBUG: \(personagens)")
        }
    }
}
