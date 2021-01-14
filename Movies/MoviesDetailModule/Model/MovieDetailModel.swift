//
//  MovieDetailModel.swift
//  Movies
//
//  Created by Administrator on 12.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

import Foundation

// MARK: - DetailModel

struct DetailModel: Decodable {
    
    var id: Int?
    var title: String?
    var overview: String?
    var poster_path: String?
    var runtime: Int?
    var vote_average: Double?
    var genres: [Genre]?
}

// MARK: - Genre

struct Genre: Decodable {
    
    var id: Int?
    var name: String?
}
