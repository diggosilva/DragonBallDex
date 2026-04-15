//
//  DetailsViewController.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 15/04/26.
//

import UIKit

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
        let char = viewModel.char
        contentView.configure(char: char)
        navigationItem.title = char.name
    }
}
