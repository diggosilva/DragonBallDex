//
//  TransformationCell.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 17/04/26.
//

import UIKit
import SDWebImage

final class TransformationCell: UICollectionViewCell {
    
    static let identifier: String = "TransformationCell"
    
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
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 2
        return label
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
    
    func applyShadow(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 7.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        charImage.image = nil
        charNameLabel.text = nil
        contentView.backgroundColor = .systemBackground
    }
    
    private func setupHierarchy() {
        contentView.addSubview(charImage)
        contentView.addSubview(charNameLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            charImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            charImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            charImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            charImage.bottomAnchor.constraint(equalTo: charNameLabel.topAnchor),
            
            charNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            charNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            charNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            charNameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupConfigurations() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    func configure(with transformation: Char.Transformation) {
        guard let url = URL(string: transformation.image) else { return }
        
        charImage.sd_setImage(with: url)
        charNameLabel.text = transformation.name
    }
}
