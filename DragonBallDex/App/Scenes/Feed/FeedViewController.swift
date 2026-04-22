//
//  FeedViewController.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 23/03/26.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    
    private var collectionDataSource: UICollectionViewDiffableDataSource<Int, String>?
    private var searchController = UISearchController(searchResultsController: nil)
    
    private let contentView = FeedView()
    private let viewModel: any FeedViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(service: ServiceProtocol = Service()) {
        self.viewModel = FeedViewModel(service: service)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() { view = contentView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureCollectionDataSource()
        configureCollectionDelegates()
        handleStates()
        viewModel.getCharacters()
    }
    
    private func setupNavigationBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar guerreiros..."
        
        navigationItem.searchController = searchController
        navigationItem.title = "Dragon Ball"
        
        definesPresentationContext = true
        
        contentView.collectionView.keyboardDismissMode = .onDrag
    }
    
    private func configureCollectionDelegates() {
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
        applyCollectionSnapshot()
    }
    
    private func showErrorState() {
        showErrorAlert(title: "Ops! ⚠️", message: "Erro ao carregar os personagens. Tente novamente mais tarde.")
        contentView.spinner.stopAnimating()
    }
    
    private func configureCollectionDataSource() {
        collectionDataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: contentView.collectionView, cellProvider: { [weak self] collectionView, indexPath, itemId in
            guard let char = self?.viewModel.getChars().first(where: { String($0.id) == itemId }),
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.identifier, for: indexPath) as? FeedCell else { return UICollectionViewCell() }
            
            cell.configure(char: char)
            return cell
        })
    }
    
    private func applyCollectionSnapshot(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        
        let ids = viewModel.getChars().map({ String($0.id) })
        snapshot.appendItems(ids)
        collectionDataSource?.apply(snapshot, animatingDifferences: animated)
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

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let char = viewModel.charForItem(at: indexPath.item)
        let service = Service()
        let detailsVM = DetailsViewModel(char: char, service: service)
        let detailsVC = DetailsViewController(viewModel: detailsVM)
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !viewModel.isSearching && indexPath.item == viewModel.numberOfItems() - 1 {
            viewModel.getCharacters()
        }
    }
}

extension FeedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        viewModel.search(text: text)
        applyCollectionSnapshot()
    }
}
