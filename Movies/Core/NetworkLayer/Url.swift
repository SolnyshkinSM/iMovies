//
//  Url.swift
//  Movies
//
//  Created by Administrator on 10.01.2021.
//  Copyright © 2021 Administrator. All rights reserved.
//

// MARK: - Url

struct Url {
    static let apiKey = "d2828e2d9692a671f3b9b58a95b7b62e"
    static let urlPopularMovies = "https://api.themoviedb.org/3/movie/popular?api_key=" + Url.apiKey
    static let urlPoster = "https://image.tmdb.org/t/p/w500"
    static let urlDetail = "https://api.themoviedb.org/3/movie/"
    static let urlYoutube = "https://www.youtube.com/watch?v="
}
