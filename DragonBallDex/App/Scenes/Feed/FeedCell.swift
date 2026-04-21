//
//  FeedCell.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 12/04/26.
//

import UIKit
import SDWebImage

final class FeedCell: UICollectionViewCell {
    
    static let identifier: String = "FeedCell"
    
    lazy var charImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        image.image = UIImage(named: "placeholder")
        return image
    }()
    
    lazy var charNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .separator
        return label
    }()
    
    lazy var charRaceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.backgroundColor = .separator
        return label
    }()
    
    lazy var charKiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.backgroundColor = .separator
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.6
        return label
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [charNameLabel, charRaceLabel, charKiLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillEqually
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
        applyShadow(view: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        charImage.image = nil
        charNameLabel.text = nil
        charRaceLabel.text = nil
        charKiLabel.text = nil
        contentView.backgroundColor = .systemBackground
    }
    
    private func setupHierarchy() {
        contentView.addSubview(charImage)
        contentView.addSubview(vStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            charImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            charImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            charImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            charImage.bottomAnchor.constraint(equalTo: vStack.topAnchor),
            
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            vStack.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    private func setupConfigurations() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    func configure(char: Char) {
        guard let url = URL(string: char.image) else { return }
        
        charImage.sd_setImage(with: url)
        charNameLabel.text = char.name
        charRaceLabel.text = char.race
        charKiLabel.text = char.formattedKi
    }
}
