//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Administrator on 07.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import UIKit

// MARK: - MovieTableViewCell

final class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Private properties
    
    private let posterImageView = UIImageView()
    private let flagImageView = UIImageView()
    private let starImageView = UIImageView()
    private let titleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let languageLabel = UILabel()
    private let voteLabel = UILabel()
    private let ratingLabel = UILabel()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by:
            UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    // MARK: - Public methods
    
    func set(movie: Movie) {
        setTitle(movie: movie)
        setFlag(movie: movie)
        setVoteAverage(movie: movie)
        setRelease(movie: movie)
        setPoster(movie: movie)
    }
    
    // MARK: - Private methods
    
    private func setTitle(movie: Movie) {
        titleLabel.text = movie.title
    }
    
    private func setFlag(movie: Movie) {

        languageLabel.text = NSLocalizedString("Language:", comment: "")
        
        if let imageName = movie.original_language,
            let image = UIImage(named: imageName) {
            flagImageView.image = image
        }
    }
    
    private func setVoteAverage(movie: Movie) {
        
        voteLabel.text = NSLocalizedString("Rating:", comment: "")
        
        if let image = UIImage(named: "star") {
            starImageView.image = image
        }
        
        if let rating = movie.vote_average {
            ratingLabel.text = String(format: "%.1f", rating)
            
            switch rating {
            case  ...5: ratingLabel.textColor = .black
            case 5...8: ratingLabel.textColor = #colorLiteral(red: 1, green: 0.6361564398, blue: 0.002340860199, alpha: 1)
            case 8... : ratingLabel.textColor = .red
            default: break
            }
        }
    }
    
    private func setRelease(movie: Movie) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormatterGet
        
        if let dateString = movie.release_date,
            let date = dateFormatter.date(from: dateString) {
            
            dateFormatter.dateFormat = Constants.dateFormatterPrint
            releaseDateLabel.text = dateFormatter.string(from: date)
        }
    }
    
    private func setPoster(movie: Movie) {
        
        if let image = cacheImage.object(forKey: movie) {
            posterImageView.image = image as? UIImage
        } else {
            
            if let posterPath = movie.poster_path,
                let url = URL(string: Url.urlPoster + posterPath) {
                posterImageView.loadData(url: url, forMovie: movie)
            }
        }
    }
}

// MARK: - Setupes

private extension MovieTableViewCell {
    
    func setupViews() {
        
        setupContentView()
        
        addViews()
        
        configureTitleLabel()
        configurePosterImageView()
        configureFlagImageView()
        configureStarImageView()
        configureReleaseLabel()
        configureLanguageLabel()
        configureVoteLabel()
        configureRatingLabel()
                
        layout()
    }
}

// MARK: - Setup elements

private extension MovieTableViewCell {
    
    func setupContentView() {
        
        backgroundColor = .clear

        layer.masksToBounds = false
        layer.shadowOpacity = 0.7
        layer.cornerRadius = 4
        layer.shadowColor = UIColor.black.cgColor

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
    }
    
    func addViews() {
        addSubview(posterImageView)
        addSubview(flagImageView)
        addSubview(starImageView)
        addSubview(ratingLabel)
    }
    
    func configureTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
    }
    
    func configurePosterImageView() {
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = bounds.height / 4
        posterImageView.sizeToFit()
    }
    
    func configureFlagImageView() {
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.clipsToBounds = true
        flagImageView.sizeToFit()
    }
    
    func configureStarImageView() {
        starImageView.contentMode = .scaleAspectFit
        starImageView.clipsToBounds = true
        starImageView.sizeToFit()
    }
    
    func configureReleaseLabel() {
        releaseDateLabel.font = .boldSystemFont(ofSize: 18)
        releaseDateLabel.adjustsFontSizeToFitWidth = true
        releaseDateLabel.minimumScaleFactor = 0.1
        releaseDateLabel.sizeToFit()
    }
    
    func configureLanguageLabel() {
        languageLabel.font = .boldSystemFont(ofSize: 14)
        languageLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        languageLabel.sizeToFit()
    }
    
    func configureVoteLabel() {
        voteLabel.font = .boldSystemFont(ofSize: 14)
        voteLabel.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        voteLabel.sizeToFit()
    }
    
    func configureRatingLabel() {
        ratingLabel.font = .boldSystemFont(ofSize: 20)
        ratingLabel.sizeToFit()
    }
}

// MARK: - Layout

private extension MovieTableViewCell {
    
    func layout() {
                
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 10),
            posterImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 5),
            posterImageView.heightAnchor.constraint(
                equalToConstant: bounds.width * 0.7),
            posterImageView.widthAnchor.constraint(
                equalToConstant: bounds.width * 0.46),
            posterImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10)
        ])
                
        let stackViewTitle = UIStackView(arrangedSubviews: [titleLabel, releaseDateLabel])
        stackViewTitle.axis = .vertical
        stackViewTitle.distribution = .fillEqually
        stackViewTitle.spacing = 10
        addSubview(stackViewTitle)
        
        NSLayoutConstraint.activate([
            stackViewTitle.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 30),
            stackViewTitle.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 10),
            stackViewTitle.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -10)
        ])
        
        let stackViewDetail = UIStackView(arrangedSubviews: [languageLabel, voteLabel])
        stackViewDetail.alignment = .center
        stackViewDetail.axis = .horizontal
        stackViewDetail.distribution = .fillEqually
        addSubview(stackViewDetail)
        
        NSLayoutConstraint.activate([
            stackViewDetail.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 10),
            stackViewDetail.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            flagImageView.topAnchor.constraint(
                equalTo: stackViewDetail.bottomAnchor,
                constant: 0),
            flagImageView.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 10),
            flagImageView.heightAnchor.constraint(
                equalTo: posterImageView.widthAnchor,
                multiplier: 0.3),
            flagImageView.widthAnchor.constraint(
                equalTo: flagImageView.heightAnchor),
            flagImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            starImageView.topAnchor.constraint(
                equalTo: stackViewDetail.bottomAnchor,
                constant: 0),
            starImageView.leadingAnchor.constraint(
                equalTo: stackViewDetail.centerXAnchor,
                constant: 0),
            starImageView.heightAnchor.constraint(
                equalTo: posterImageView.widthAnchor,
                multiplier: 0.3),
            starImageView.widthAnchor.constraint(
                equalTo: starImageView.heightAnchor),
            starImageView.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            ratingLabel.topAnchor.constraint(
                equalTo: stackViewDetail.bottomAnchor,
                constant: 0),
            ratingLabel.leadingAnchor.constraint(
                equalTo: starImageView.trailingAnchor,
                constant: 0),
            ratingLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -10),
            ratingLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10)
        ])
                
        let collectionView = [posterImageView, stackViewTitle, stackViewDetail, flagImageView, starImageView, ratingLabel]
        
        collectionView.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
                
    }
}

// MARK: - Constants

extension MovieTableViewCell {
    
    enum Constants {
        static let dateFormatterGet = "yyyy-MM-dd"
        static let dateFormatterPrint = "dd MMM, yyyy"
    }
}
