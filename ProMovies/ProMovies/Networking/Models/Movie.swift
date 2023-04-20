//
//  Movies.swift
//  ProMovies
//
//  Created by Jane Strashok on 13.03.2023.
//

import Foundation

struct Movie: Codable {
    var posterPath: String?
    var originalTitle: String?
    var genreIds: [Int]?
    var id: Int

    
    let backdropPath: String?
    let originalLanguage: String?
    var overview: String?
    let runtime: Int?
    let title: String?
    var voteAverage: Double?
}


