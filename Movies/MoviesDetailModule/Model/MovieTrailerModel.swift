//
//  MovieTrailerModel.swift
//  Movies
//
//  Created by Administrator on 12.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import Foundation

// MARK: - Trailers

struct Trailers: Decodable {
    
    var id: Int?
    var results: [Video]?
}

// MARK: - Video

struct Video: Decodable {
    
    var key: String?
    var site: String?
}
