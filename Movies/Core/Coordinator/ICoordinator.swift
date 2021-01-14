//
//  ICoordinator.swift
//  Movies
//
//  Created by Administrator on 10.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import UIKit

// MARK: - ICoordinator

protocol ICoordinator {    
    var navigationController: UINavigationController { get }
    func start()
}
