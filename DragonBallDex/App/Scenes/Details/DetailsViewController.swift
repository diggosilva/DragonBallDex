//
//  DetailsViewController.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 15/04/26.
//

import UIKit
import Combine

class DetailsViewController: UIViewController {
    
    private let contentView = DetailsView()
    private var viewModel: any DetailsViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: any DetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() { view = contentView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupNavigationBar()
        setupDataSourcesAndDelegates()
        handleStates()
        viewModel.fetchDetails()
    }
    
    private func setupData() {
        contentView.configure(char: viewModel.char)
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
    
    private func handleStates() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                
                switch state {
                case .idle: break
                case .loading: showLoadingState()
                case .loaded: showLoadedState()
                case .error: showErrorState()
                }
            }.store(in: &cancellables)
    }
    
    private func showLoadingState() {
        contentView.spinner.startAnimating()
    }
    
    private func showLoadedState() {
        contentView.spinner.stopAnimating()
        contentView.configure(char: viewModel.char)
    }
    
    private func showErrorState() {
        showErrorAlert(title: "Ops! ⚠️", message: "Não foi possível carregar os detalhes.")
    }
}

extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.char.transformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransformationCell.identifier, for: indexPath) as? TransformationCell else { return UICollectionViewCell() }
        
        cell.configure(with: viewModel.char.transformations[indexPath.item])
        return cell
    }
}

extension DetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transformation = viewModel.char.transformations[indexPath.item]
        updateCharacterData(with: transformation)
    }
    
    private func updateCharacterData(with transformation: Char.Transformation) {
        let char = viewModel.char
        
        let transformedChar = Char(
            id: char.id,
            name: transformation.name,
            ki: transformation.ki,
            maxKi: char.maxKi,
            race: char.race,
            gender: char.gender,
            description: "Transformação de \(char.name)",
            image: transformation.image,
            affiliation: char.affiliation,
            transformations: char.transformations
        )
        
        UIView.transition(with: contentView, duration: 0.3, options: .transitionCrossDissolve) {
            self.contentView.configure(char: transformedChar)
            self.navigationItem.title = transformedChar.name
        }
        
        contentView.scrollView.setContentOffset(.zero, animated: true)
    }
}
