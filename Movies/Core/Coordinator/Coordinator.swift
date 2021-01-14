//
//  Coordinator.swift
//  Movies
//
//  Created by Administrator on 10.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import UIKit

// MARK: - Coordinator

/**
Coordinator pattern
*/

final class Coordinator: ICoordinator {
    
    // MARK: - Public properties
    
    var navigationController: UINavigationController
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Public methods
    
    func start() {
        goToMoviesViewController()
    }
    
    // MARK: - Private methods
    
    private func goToMoviesViewController() {
        
        let viewController = MovieViewController()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - IMoviesCoordinator

extension Coordinator: IMoviesCoordinator {
    
    func goToMoviesDetailViewController(id: Int) {
        
        let viewController = MovieDetailViewController()
        viewController.selectIdTwo = id
        navigationController.pushViewController(viewController, animated: true)
    }
}
