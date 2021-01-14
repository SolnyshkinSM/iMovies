//
//  MovieModel.swift
//  Movies
//
//  Created by Administrator on 12.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import Foundation

// MARK: - Results

struct Results: Decodable {
    
    var page: Int?
    var results: [Movie]?
}

// MARK: - Movie

struct Movie: Decodable {
    
    var id: Int?
    var title: String?
    var poster_path: String?
    var release_date: String?
    var original_language: String?
    var vote_average: Double?
}
