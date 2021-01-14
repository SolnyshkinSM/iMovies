//
//  GenreCollectionViewCell.swift
//  Movies
//
//  Created by Administrator on 13.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import UIKit

// MARK: - GenreCollectionViewCell

final class GenreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public properties
    
    var genre: Genre? {
        didSet {
            infoLabel.text = genre?.name
        }
    }
    
    // MARK: - Private properties
    
    private let infoLabel = UILabel()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setupes

private extension GenreCollectionViewCell {
    
    func setupViews() {
        
        setupContentView()
        
        addViews()
        
        configureInfoLabel()
                        
        layout()
    }
}

// MARK: - Setup elements

private extension GenreCollectionViewCell {
    
    func setupContentView() {
        
        backgroundColor = .purple
        
        layer.masksToBounds = false
        layer.cornerRadius = bounds.height / 2
    }
    
    func addViews() {
        addSubview(infoLabel)
    }
    
    func configureInfoLabel() {
        infoLabel.font = .boldSystemFont(ofSize: 10)
        infoLabel.textAlignment = .center
        infoLabel.textColor = .white
        //infoLabel.adjustsFontSizeToFitWidth = true
        //infoLabel.minimumScaleFactor = 0.1
        infoLabel.sizeToFit()
    }
}

// MARK: - Layout

private extension GenreCollectionViewCell {
    
    func layout() {
                
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor),
            infoLabel.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor),
            infoLabel.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor),
            infoLabel.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
                        
        let collectionView = [infoLabel]
        
        collectionView.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
                
    }
}
