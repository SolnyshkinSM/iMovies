//
//  MovieDetailViewController.swift
//  Movies
//
//  Created by Administrator on 09.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import UIKit
import SafariServices

// MARK: - MovieDetailViewController

final class MovieDetailViewController: UIViewController {
    
    // MARK: - Public properties
    
    var selectIdTwo = Int()
    
    var movie: Movie?
    
    // MARK: - Private properties
    
    private var movieDetail: DetailModel! {
        didSet { set(detailModel: movieDetail) }
    }
    
    private var trailers: Trailers!
    private var genres: [Genre]?
    
    private var genresCollectionView: UICollectionView!
    
    private let posterImageView = FactoryImageView.shared.createImageView()
    private let backgroundImageView = FactoryImageView.shared.createImageView()
    private let starImageView = FactoryImageView.shared.createImageView()
    private let clockImageView = FactoryImageView.shared.createImageView()
    private let runTimeLabel = FactoryLabel.shared.createLabel(fontOfSize: 15, andColor: .black)
    private let infoLabel = FactoryLabel.shared.createLabel(fontOfSize: 20, andColor: .black)
    private let overviewLabel = FactoryLabel.shared.createLabel(fontOfSize: 15, andColor: .gray)
    private let ratingLabel = FactoryLabel.shared.createLabel(fontOfSize: 15, andColor: .black)
    private let trailerButton = UIButton()
    
    private lazy var collectionView = [backgroundImageView, posterImageView, starImageView, infoLabel, clockImageView, runTimeLabel, ratingLabel, overviewLabel, trailerButton]
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBinding()
    }
    
    // MARK: - Private methods
    
    private func loadDetails() {
        
        let urlString = Url.urlDetail + String(selectIdTwo) + "?api_key=" + Url.apiKey
        
        if let url = URL.init(string: urlString) {
            NetworkLayer.shared.getData(url: url) { [weak self] (item: DetailModel) in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.movieDetail = item
                    self.genres = item.genres
                    self.genresCollectionView.reloadData()
                }
            }
        }
    }
    
    private func loadTrailers() {
        
        let urlString = Url.urlDetail + String(selectIdTwo) + "/videos?api_key=" + Url.apiKey
        
        if let url = URL.init(string: urlString) {
            NetworkLayer.shared.getData(url: url) { [weak self] (items: Trailers) in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.trailers = items
                }
            }
        }
    }
    
    private func set(detailModel: DetailModel) {
        
        setInfo(object: detailModel)
        setOverview(object: detailModel)
        setRunTime(object: detailModel)
        setVoteAverage(object: detailModel)
        setPoster(object: detailModel)
    }
    
    private func setInfo(object: DetailModel) {
        infoLabel.text = object.title
    }
    
    private func setVoteAverage(object: DetailModel) {
        
        if let image = UIImage(named: "star") {
            starImageView.image = image
        }
        
        if let rating = object.vote_average {
            ratingLabel.text = String(format: "%.1f", rating)
            
            switch rating {
            case  ...5: ratingLabel.textColor = .black
            case 5...8: ratingLabel.textColor = #colorLiteral(red: 1, green: 0.6361564398, blue: 0.002340860199, alpha: 1)
            case 8... : ratingLabel.textColor = .red
            default: break
            }
        }
    }
    
    private func setRunTime(object: DetailModel) {
        
        clockImageView.image = UIImage(named: "clock")
        
        if let runTime = object.runtime {
            let hors = runTime / 60
            let minutes = runTime % 60
            runTimeLabel.text = "\(hors)h " + "\(minutes)" + "min"
        }
    }
    
    private func setOverview(object: DetailModel) {
        overviewLabel.text = object.overview
    }
    
    private func setPoster(object: DetailModel) {
        
        if let movie = movie, let image = cacheImage.object(forKey: movie) as? UIImage {
            backgroundImageView.image = image
            backgroundImageView.toApplyBlurEffect()
            posterImageView.image = image
        } else {
            
            if let posterPath = object.poster_path,
                let url = URL(string: Url.urlPoster + posterPath) {
                backgroundImageView.loadData(url: url, forMovie: movie)
                backgroundImageView.toApplyBlurEffect()
                posterImageView.loadData(url: url, forMovie: movie)
            }
        }
    }
    
    @objc private func pressedTrailerButton(_ sender: UIButton) {
        
        if let trailer = trailers.results?.first,
            let key = trailer.key,
            trailer.site == "YouTube" {
            
            if let url = URL(string: Url.urlYoutube + key) {
                let safari = SFSafariViewController(url: url)
                navigationController?.present(safari, animated: true, completion: nil)
            }
        } else {
            
            let alert = UIAlertController(title: NSLocalizedString("info", comment: ""), message: NSLocalizedString("no trailer", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Setupes

private extension MovieDetailViewController {
    
    func setupViews() {
        
        setupContentView()
        
        addViews()
        
        configurePosterImageView()
        configureInfoLabel()
        configureOverviewLabel()
        configureTrailerButton()
        
        configureGenresCollectionView()
        
        layout()
    }
    
    func setupBinding() {
        
        loadDetails()
        loadTrailers()
    }
}

// MARK: - Setup elements

private extension MovieDetailViewController {
    
    func setupContentView() {
        view.backgroundColor = .white
    }
    
    func addViews() {
        collectionView.forEach(view.addSubview)
    }
        
    func configurePosterImageView() {
        posterImageView.layer.cornerRadius = 20
    }
        
    func configureGenresCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        
        let inset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        layout.sectionInset = inset
        
        genresCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        genresCollectionView.backgroundColor = .clear
        genresCollectionView.showsHorizontalScrollIndicator = false
        genresCollectionView.dataSource = self
        genresCollectionView.delegate = self
        
        genresCollectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: Constants.collectionCellIdentifier)
        
        view.addSubview(genresCollectionView)
    }
    
    func configureInfoLabel() {
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
    }
    
    func configureOverviewLabel() {
        overviewLabel.numberOfLines = 0
    }
    
    func configureTrailerButton() {
        trailerButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        trailerButton.sizeToFit()
        trailerButton.layer.cornerRadius = trailerButton.bounds.height / 2
        
        let titleButton = NSLocalizedString("Show trailer", comment: "")
        trailerButton.setTitle(titleButton, for: .normal)

        trailerButton.layer.borderWidth = 2
        trailerButton.layer.borderColor = UIColor.white.cgColor
        
        trailerButton.addTarget(self, action: #selector(pressedTrailerButton(_:)), for: .touchUpInside)
    }
}

// MARK: - Layout

private extension MovieDetailViewController {
    
    func layout() {
        
        let area = view.safeAreaLayoutGuide
        let minWidth = min(view.bounds.width, view.bounds.height)
        var overviewConstraint = [NSLayoutConstraint]()
        
        overviewConstraint += [
            backgroundImageView.topAnchor.constraint(
                equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ]
        
        overviewConstraint += [
            posterImageView.topAnchor.constraint(
                equalTo: area.topAnchor,
                constant: 10),
            posterImageView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 10),
            posterImageView.heightAnchor.constraint(
                equalToConstant: minWidth * 0.7),
            posterImageView.widthAnchor.constraint(
                equalToConstant: minWidth * 0.46),
        ]

        overviewConstraint += [
            infoLabel.topAnchor.constraint(
                equalTo: area.topAnchor,
                constant: 10),
            infoLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 10),
            infoLabel.trailingAnchor.constraint(
                equalTo: area.trailingAnchor,
                constant: -10)
        ]
        
        overviewConstraint += [
            starImageView.topAnchor.constraint(
                equalTo: infoLabel.bottomAnchor,
                constant: 10),
            starImageView.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 10),
            starImageView.heightAnchor.constraint(
                equalTo: posterImageView.widthAnchor,
                multiplier: 0.2),
            starImageView.widthAnchor.constraint(
                equalTo: starImageView.heightAnchor),
        ]
        
        overviewConstraint += [
            ratingLabel.centerYAnchor.constraint(
                equalTo: starImageView.centerYAnchor),
            ratingLabel.leadingAnchor.constraint(
                equalTo: starImageView.trailingAnchor,
                constant: 0),
        ]
        
        overviewConstraint += [
            clockImageView.topAnchor.constraint(
                equalTo: infoLabel.bottomAnchor,
                constant: 10),
            clockImageView.leadingAnchor.constraint(
                equalTo: ratingLabel.trailingAnchor,
                constant: 10),
            clockImageView.heightAnchor.constraint(
                equalTo: posterImageView.widthAnchor,
                multiplier: 0.2),
            clockImageView.widthAnchor.constraint(
                equalTo: starImageView.heightAnchor),
        ]
        
        overviewConstraint += [
            runTimeLabel.centerYAnchor.constraint(
                equalTo: clockImageView.centerYAnchor),
            runTimeLabel.leadingAnchor.constraint(
                equalTo: clockImageView.trailingAnchor,
                constant: 0),
            runTimeLabel.trailingAnchor.constraint(
                equalTo: area.trailingAnchor,
                constant: -10),
        ]
        
        overviewConstraint += [
            genresCollectionView.topAnchor.constraint(
                equalTo: starImageView.bottomAnchor,
                constant: 10),
            genresCollectionView.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 10),
            genresCollectionView.trailingAnchor.constraint(
                equalTo: area.trailingAnchor,
                constant: -10),
            genresCollectionView.heightAnchor.constraint(
                equalToConstant: 22)
        ]
        
        if UIDevice.current.orientation == .portrait || UIDevice.current.orientation == .unknown {
            overviewConstraint += [
                overviewLabel.topAnchor.constraint(
                    equalTo: posterImageView.bottomAnchor,
                    constant: 10),
                overviewLabel.leadingAnchor.constraint(
                    equalTo: area.leadingAnchor,
                    constant: 10)
            ]
        } else {
            overviewConstraint += [
                overviewLabel.leadingAnchor.constraint(
                    equalTo: posterImageView.trailingAnchor,
                    constant: 10)
            ]
        }
        
        overviewConstraint += [
            overviewLabel.trailingAnchor.constraint(
                equalTo: area.trailingAnchor,
                constant: -10)
        ]
        
        overviewConstraint += [
            trailerButton.topAnchor.constraint(
                greaterThanOrEqualTo: overviewLabel.bottomAnchor,
                constant: 10),
            trailerButton.centerXAnchor.constraint(
                equalTo: area.centerXAnchor),
            trailerButton.widthAnchor.constraint(
                equalTo: area.widthAnchor,
                multiplier: 0.5),
            trailerButton.heightAnchor.constraint(
                equalToConstant: 44),
            trailerButton.bottomAnchor.constraint(
                equalTo: area.bottomAnchor,
                constant: -10)
        ]
        
        NSLayoutConstraint.activate(overviewConstraint)
        
        collectionView.append(genresCollectionView)
        
        collectionView.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
    }
}

// MARK: - UICollectionViewDataSource

extension MovieDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionCellIdentifier, for: indexPath) as? GenreCollectionViewCell else { return UICollectionViewCell() }
                
        cell.genre = genres?[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension MovieDetailViewController: UICollectionViewDelegate {}

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        return CGSize(width: collectionView.bounds.width * 0.3, height: collectionView.bounds.height)
    }
}

// MARK: - Constants

extension MovieDetailViewController {
    
    enum Constants {
        static let collectionCellIdentifier = "CellCollection"
    }
}
