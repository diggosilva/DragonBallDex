//
//  FeedCell.swift
//  DragonBallDex
//
//  Created by Diggo Silva on 12/04/26.
//

import UIKit
import SDWebImage
import UIImageColors

final class FeedCell: UICollectionViewCell {
    
    static let identifier: String = "FeedCell"
    
    private var currentRepresentedIdentifier: Int?
    
    lazy var charImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 8
        return image
    }()
    
    lazy var charNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .tertiarySystemBackground
        return label
    }()
    
    lazy var charRaceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .center
        label.backgroundColor = .tertiarySystemBackground
        return label
    }()
    
    lazy var charKiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.backgroundColor = .tertiarySystemBackground
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 2. Reseta o ID para invalidar qualquer processo assíncrono antigo
        currentRepresentedIdentifier = nil
        
        charImage.sd_cancelCurrentImageLoad() // Força o cancelamento do SDWebImage
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
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }
    
    func configure(char: Char) {
        // 3. Define o ID atual desta configuração
        currentRepresentedIdentifier = char.id
        
        guard let url = URL(string: char.image) else { return }
        
        charNameLabel.text = char.name
        charRaceLabel.text = char.race
        charKiLabel.text = char.formattedKi
        
        charImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder")) { [weak self] image, _, _, _ in
            guard let self = self, let image = image else { return }
            
            // 4. Inicia a extração de cores (Processo pesado)
            image.getColors { [weak self] colors in
                DispatchQueue.main.async {
                    // 5. A MÁGICA: Só aplica a cor se o ID da célula ainda for o mesmo do início da função
                    if self?.currentRepresentedIdentifier == char.id {
                        UIView.animate(withDuration: 0.3) {
                            self?.contentView.backgroundColor = colors?.secondary.withAlphaComponent(0.5)
                        }
                    }
                }
            }
        }
    }
}
