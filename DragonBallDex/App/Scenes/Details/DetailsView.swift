//
//  DetailsView.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 15/04/26.
//

import UIKit
import SDWebImage

final class DetailsView: UIView {
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var charImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    lazy var raceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()
    
    lazy var descriptionLabelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Descrição:"
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .justified
        return label
    }()
    
    lazy var kiLabelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Ki Total"
        label.textAlignment = .left
        return label
    }()
    
    lazy var kiLabelValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemOrange
        label.textAlignment = .right
        return label
    }()
    
    lazy var kiStatStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [kiLabelTitle, kiLabelValue])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var maxKiLabelTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "Max Ki"
        label.textAlignment = .left
        return label
    }()
    
    lazy var maxKiLabelValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemOrange
        label.textAlignment = .right
        return label
    }()
    
    lazy var maxKiStatStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [maxKiLabelTitle, maxKiLabelValue])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [kiStatStack, maxKiStatStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
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
        addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        containerView.addSubview(charImage)
        containerView.addSubview(nameLabel)
        containerView.addSubview(raceLabel)
        containerView.addSubview(divider)
        containerView.addSubview(descriptionLabelTitle)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(vStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            charImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            charImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            charImage.heightAnchor.constraint(equalToConstant: 300),
            
            nameLabel.topAnchor.constraint(equalTo: charImage.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            raceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            raceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            raceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            divider.topAnchor.constraint(equalTo: raceLabel.bottomAnchor, constant: 16),
            divider.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionLabelTitle.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16),
            descriptionLabelTitle.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabelTitle.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionLabelTitle.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            vStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            vStack.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupConfigurations() {
        backgroundColor = .secondarySystemBackground
    }
    
    func configure(char: Char) {
        guard let url = URL(string: char.image) else { return }
        
        charImage.sd_setImage(with: url)
        nameLabel.text = char.name
        raceLabel.text = "Race: \(char.race) - \(char.gender)"
        descriptionLabel.text = char.description
        kiLabelValue.text = char.formattedKiDetails
        maxKiLabelValue.text = char.formattedMaxKiDetails
    }
}
