//
//  FeedViewController.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 23/03/26.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    
    private let contentView = FeedView()
    private let viewModel: any FeedViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ServiceProtocol = Service()) {
        self.viewModel = FeedViewModel(service: service)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupDataSourcesAndDelegates()
        handleStates()
        viewModel.getCharacters()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Dragon Ball"
    }
    
    private func setupDataSourcesAndDelegates() {
        contentView.collectionView.dataSource = self
        contentView.collectionView.delegate = self
    }
    
    private func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .idle: break
            case .loading: return showLoadingState()
            case .loaded:  return showLoadedState()
            case .error:   return showErrorState()
            }
        }.store(in: &cancellables)
    }
    
    private func showLoadingState() {
        contentView.spinner.startAnimating()
    }
    
    private func showLoadedState() {
        contentView.spinner.stopAnimating()
        contentView.collectionView.reloadData()
    }
    
    private func showErrorState() {
        showErrorAlert(title: "Ops! ⚠️", message: "Erro ao carregar os personagens. Tente novamente mais tarde.")
        contentView.spinner.stopAnimating()
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let itemsPerRow: CGFloat = 2
        
        let totalSpacing =
        layout.sectionInset.left +
        layout.sectionInset.right +
        (layout.minimumInteritemSpacing * (itemsPerRow - 1))
        
        let rawWidth = (collectionView.bounds.width - totalSpacing) / itemsPerRow
        let width = floor(rawWidth)
        
        return CGSize(width: width, height: width * 1.5)
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else { return UICollectionViewCell() }
        let char = viewModel.charForItem(at: indexPath.item)
        cell.configure(char: char)
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Clicou em: \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.numberOfItems() - 1 {
            viewModel.getCharacters()
        }
    }
}

// MARK: Actions

extension FeedViewController {
    func showErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
