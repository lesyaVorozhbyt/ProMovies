//
//  Movies.swift
//  ProMovies
//
//  Created by Jane Strashok on 13.03.2023.
//

import Foundation

struct Movie: Codable {
    let backdropPath: String?
    let genres: [Int: String]
    let originalLanguage: String
    let originalTitle: String
    var overview: String?
    let posterPath: String?
    
}
