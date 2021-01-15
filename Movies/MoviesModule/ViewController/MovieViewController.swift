//
//  MovieViewController.swift
//  Movies
//
//  Created by Administrator on 07.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import UIKit

// MARK: - MovieViewController

final class MovieViewController: UIViewController {
    
    // MARK: - Public properties
    
    public var coordinator: IMoviesCoordinator?
    
    // MARK: - Private properties
    
    private var numberPage = 1 { didSet { loadData() } }
    
    private let networkLayer = NetworkLayer()
    
    private lazy var results = Results()
    
    private let movieTableView = UITableView()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupViews()
        setupBinding()
        setupScreenSaver()
    }
    
    // MARK: - Private methods
    
    private func loadData() {
        
        if let url = URL(string: Url.urlPopularMovies + "&page=\(numberPage)") {
            networkLayer.getData(url: url) { [weak self] (items: Results) in
                
                guard let self = self else { return }
                
                self.results = items
                DispatchQueue.main.sync {
                    self.movieTableView.reloadData()
                }
            }
        }
    }
    
    @objc private func refreshMovieTableView() {
        numberPage += 1
        movieTableView.refreshControl?.endRefreshing()
    }
}

// MARK: - Setupes

private extension MovieViewController {
    
    func setupViews() {
        addViews()
        setupTableView()
        setupRefreshControl()
        configureNavigationController()
        layout()
    }
    
    func setupBinding() {
        loadData()
    }
    
    func setupScreenSaver() {
        
        let screensaver = UIImageView(frame: view.bounds)
        screensaver.backgroundColor = .white
        screensaver.contentMode = .center
        screensaver.image = UIImage(named: "logo")
        screensaver.clipsToBounds = true
        view.addSubview(screensaver)
        
        UIView.animate(withDuration: 3) {
            screensaver.alpha = 0
            self.navigationController?.navigationBar.alpha = 1
        }
    }
}

// MARK: - Setup elements

private extension MovieViewController {
    
    func addViews() {
        view.addSubview(movieTableView)
    }
    
    func setupTableView() {
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.rowHeight = UITableView.automaticDimension
        movieTableView.separatorStyle = .none
        movieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: Cells.movieCells)
    }
    
    func setupRefreshControl() {
        
        movieTableView.refreshControl = UIRefreshControl()
        movieTableView.refreshControl?.backgroundColor = .white
        movieTableView.refreshControl?.tintColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        movieTableView.refreshControl?.addTarget(self, action: #selector(refreshMovieTableView), for: .valueChanged)
    }
    
    func configureNavigationController() {
        
        navigationItem.title = Constants.title
        navigationController?.navigationBar.alpha = 0
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - Layout

private extension MovieViewController {
    
    func layout() {
        
        movieTableView.translatesAutoresizingMaskIntoConstraints = false
        
        let area = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            movieTableView.topAnchor.constraint(equalTo: area.topAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: area.bottomAnchor),
            movieTableView.leadingAnchor.constraint(equalTo: area.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: area.trailingAnchor)
        ])
    }
}

// MARK: - UITableViewDelegate

extension MovieViewController: UITableViewDelegate {}

// MARK: - UITableViewDataSource

extension MovieViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.results?.count ?? Constants.zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Cells.movieCells, for: indexPath) as? MovieTableViewCell
            else { return UITableViewCell() }
        
        guard let movie = results.results?[indexPath.row] else { return UITableViewCell() }
        
        cell.set(movie: movie)
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        if let id = results.results?[indexPath.row].id {
            coordinator?.goToMoviesDetailViewController(id: id)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Constants

private extension MovieViewController {
    
    enum Constants {
        static let zero = 0
        static let title = NSLocalizedString("Popular", comment: "")
    }
    
    enum Cells {
        static let movieCells = "MovieCells"
    }
}
