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
    private var viewModel: DetailsViewModelProtocol
    
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
        setupDataSourcesAndDelegates()
        bindViewModel()
        viewModel.fetchDetails()
    }
    
    private func setupData() {
        let char = viewModel.char
        contentView.configure(char: char)
        contentView.charImage.hero.id = "char_image_\(String(char.id))"
        contentView.charImage.hero.modifiers = [.arc, .spring(stiffness: 250, damping: 25)]
        view.hero.modifiers = [.cascade]
    }
    
    private func setupNavigationBar() {
        let char = viewModel.char
        contentView.configure(char: char)
        navigationItem.title = char.name
    }
    
    private func setupDataSourcesAndDelegates() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdate = { [weak self] fullChar in
            self?.contentView.configure(char: fullChar)
        }
    }
}

extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.char.transformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransformationCell.identifier, for: indexPath) as? TransformationCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: viewModel.char.transformations[indexPath.item])
        
        return cell
    }
}

extension DetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
