//
//  FeedView.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 09/04/26.
//

import UIKit

final class FeedView: UIView {
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        let inset: CGFloat = 16
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.backgroundColor = .secondarySystemBackground
        return collection
    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        setupHierarchy()
        setupConstraints()
        setupConfigurations()
    }
    
    private func setupHierarchy() {
        addSubview(collectionView)
        addSubview(spinner)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupConfigurations() {
        backgroundColor = .systemBackground
    }
}
