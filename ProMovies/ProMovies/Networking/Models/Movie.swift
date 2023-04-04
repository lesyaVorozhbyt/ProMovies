//
//  Movies.swift
//  ProMovies
//
//  Created by Jane Strashok on 13.03.2023.
//

import Foundation

struct Movie: Codable {
    let backdropPath: String?
    var genres: [Genre]
    let originalLanguage: String
    var overview: String?
    let posterPath: String?
    let runtime: Int
    let title: String
    var voteAverage: Double
}
