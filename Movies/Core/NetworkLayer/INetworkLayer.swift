//
//  INetworkLayer.swift
//  Movies
//
//  Created by Administrator on 10.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import Foundation

// MARK: - INetworkLayer

protocol INetworkLayer {
    func getData<T: Decodable>(url: URL, completion: @escaping (T) -> Void)
}
