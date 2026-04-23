//
//  DetailsView.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 15/04/26.
//

import UIKit
import SDWebImage

final class DetailsView: UIView {
    
    private var transformations: [Char.Transformation] = []
    
    // MARK: - UI Components
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 20, right: 16)
        return stack
    }()
    
    lazy var charImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.heightAnchor.constraint(equalToConstant: 300).isActive = true
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    lazy var descriptionLabelTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Descrição:"
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    // Stats (Ki)
    lazy var kiLabelValue: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemOrange
        label.textAlignment = .right
        return label
    }()
    
    lazy var maxKiLabelValue: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemOrange
        label.textAlignment = .right
        return label
    }()
    
    lazy var statsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layer.cornerRadius = 8
        stack.backgroundColor = .tertiarySystemBackground
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        applyShadow(view: stack)
        return stack
    }()
    
    // Planeta
    lazy var planetImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
        image.heightAnchor.constraint(equalToConstant: 80).isActive = true
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var planetName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    lazy var planetInfo: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    lazy var planetInfoStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [planetName, planetInfo])
        stack.axis = .vertical
        return stack
    }()
    
    lazy var planetStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [planetImage, planetInfoStack])
        stack.axis = .horizontal
        stack.layer.cornerRadius = 8
        stack.spacing = 8
        stack.backgroundColor = .tertiarySystemBackground
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        applyShadow(view: stack)
        return stack
    }()
    
    // Transformações
    lazy var transformationsSection: UIStackView = {
        let divider = UIView()
        divider.backgroundColor = .systemGray4
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let title = UILabel()
        title.text = "Transformações"
        title.font = .systemFont(ofSize: 20, weight: .bold)
        
        let stack = UIStackView(arrangedSubviews: [divider, title, collectionView])
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 140)
        layout.minimumLineSpacing = 16
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.heightAnchor.constraint(equalToConstant: 180).isActive = true
        cv.register(TransformationCell.self, forCellWithReuseIdentifier: TransformationCell.identifier)
        return cv
    }()
    
    lazy var spinner = buildSpinner()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        backgroundColor = .secondarySystemBackground
        
        addSubview(scrollView)
        scrollView.addSubviews(mainStack, spinner)
        
        // Montando as linhas de Ki
        statsStack.addArrangedSubview(createStatRow(title: "Ki Total", valueLabel: kiLabelValue))
        statsStack.addArrangedSubview(createStatRow(title: "Max Ki", valueLabel: maxKiLabelValue))
        
        // Ordem da Main Stack
        mainStack.addArrangedSubview(charImage)
        mainStack.addArrangedSubview(nameLabel)
        mainStack.addArrangedSubview(infoLabel)
        mainStack.addArrangedSubview(divider)
        mainStack.addArrangedSubview(descriptionLabelTitle)
        mainStack.addArrangedSubview(descriptionLabel)
        mainStack.addArrangedSubview(statsStack)
        mainStack.addArrangedSubview(planetStack)
        mainStack.addArrangedSubview(transformationsSection)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            mainStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mainStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            mainStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    private func createStatRow(title: String, valueLabel: UILabel) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }
    
    // MARK: - Configuration
    func configure(char: Char) {
        guard let url = URL(string: char.image) else { return }
        guard let planetUrl = URL(string: char.originPlanet?.image ?? "") else { return }
        
        if let planetStatus = char.originPlanet?.isDestroyed {
            if planetStatus {
                planetName.text = "\(char.originPlanet?.name ?? "") - Destruído"
            } else {
                planetName.text = char.originPlanet?.name
            }
        }
        
        charImage.sd_setImage(with: url)
        nameLabel.text = char.name
        infoLabel.text = "Raça: \(char.race) - \(char.gender)\nAfiliação: \(char.affiliation)"
        descriptionLabel.text = char.description
        kiLabelValue.text = char.formattedKiDetails
        maxKiLabelValue.text = char.formattedMaxKiDetails
        planetImage.sd_setImage(with: planetUrl)
  
        planetInfo.text = char.originPlanet?.description
        
        self.transformations = char.transformations
        
        // Se estiver vazio, a seção some e a mainStack colapsa o espaço
        let hasTransformations = !char.transformations.isEmpty
        transformationsSection.isHidden = !hasTransformations
        
        if hasTransformations {
            collectionView.reloadData()
        }
        self.layoutIfNeeded()
    }
}
