//
//  DetailsViewController.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 15/04/26.
//

import UIKit
import Hero

class DetailsViewController: UIViewController {
    
    private let contentView = DetailsView()
    private let viewModel: DetailsViewModelProtocol
    
    init(viewModel: DetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        setupData()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let char = viewModel.char
        contentView.configure(char: char)
        navigationItem.title = char.name
    }
    
    private func setupData() {
        let char = viewModel.char
        contentView.configure(char: char)
        contentView.charImage.hero.id = "char_image_\(String(char.id))"
        contentView.charImage.hero.modifiers = [.arc, .spring(stiffness: 250, damping: 25)]
        view.hero.modifiers = [.cascade]
    }
}
