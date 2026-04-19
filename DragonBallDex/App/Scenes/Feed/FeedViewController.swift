//
//  FeedViewController.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 23/03/26.
//

import UIKit
import Combine
import Hero

class FeedViewController: UIViewController {
    
    private var collectionDataSource: UICollectionViewDiffableDataSource<Int, String>?
    
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
        configureCollectionDataSource()
        setupDataSourcesAndDelegates()
        handleStates()
        viewModel.getCharacters()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Dragon Ball"
        navigationController?.hero.isEnabled = true
    }
    
    private func setupDataSourcesAndDelegates() {
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
        collectionDataSource = UICollectionViewDiffableDataSource(collectionView: contentView.collectionView, cellProvider: { [weak self] collectionView, indexPath, itemId in
            guard let self = self,
                  let char = viewModel.getChars().first(where: { String($0.id) == itemId }),
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
        guard let cell = collectionView.cellForItem(at: indexPath) as? FeedCell else { return }
        let char = viewModel.charForItem(at: indexPath.item)
        
        let transitionID = "char_image_\(char.id)"
        
        cell.charImage.hero.id = transitionID
        
        let viewModel = DetailsViewModel(char: char)
        let detailsVC = DetailsViewController(viewModel: viewModel)
        
        detailsVC.hero.isEnabled = true
        navigationController?.pushViewController(detailsVC, animated: true)
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




// MARK: - Diffable Data Source & Snapshots Template (Swift 6 + MVVM + Combine)

import UIKit
import Combine

// MARK: - Properties

private var collectionDataSource: UICollectionViewDiffableDataSource<Int, String>?
private var cancellables = Set<AnyCancellable>()

// MARK: - Configure CollectionView Diffable DataSource

//private func configureCollectionDataSource() {
//    collectionDataSource = UICollectionViewDiffableDataSource<Int, String>(
//        collectionView: collectionView
//    ) { [weak self] collectionView, indexPath, itemID in
//        guard
//            let self,
//            let model = self.viewModel.getItems().first(where: { String($0.id) == itemID }),
//            let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: CustomCollectionCell.identifier,
//                for: indexPath
//            ) as? CustomCollectionCell
//        else { return UICollectionViewCell() }
//        
//        cell.configure(with: model)
//        return cell
//    }
//}

// MARK: - Apply Collection Snapshot

//private func applyCollectionSnapshot(animated: Bool = true) {
//    var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
//    snapshot.appendSections([0])
//    snapshot.appendItems(viewModel.getItems().map { String($0.id) })
//    collectionDataSource?.apply(snapshot, animatingDifferences: animated)
//}

// MARK: - Bind ViewModel with Combine

//private func bindViewModel() {
//    // State-driven UI (loading / loaded / error)
//    viewModel.statePublisher
//        .receive(on: RunLoop.main)
//        .sink { [weak self] state in
//            guard let self = self else { return }
//            switch state {
//            case .idle:
//                break
//            case .loading:
//                spinner.startAnimating()
//            case .loaded:
//                spinner.stopAnimating()
//                applyCollectionSnapshot()  // CollectionView snapshot
//            case .error(let message):
//                spinner.stopAnimating()
//                showErrorAlert(message: message)
//            }
//        }
//        .store(in: &cancellables)
//    
//    // Optional: automatic snapshot on data change (search / filter)
//    viewModel.itemsPublisher
//        .receive(on: RunLoop.main)
//        .sink { [weak self] _ in
//            self?.applyCollectionSnapshot()
//        }
//        .store(in: &cancellables)
//}
