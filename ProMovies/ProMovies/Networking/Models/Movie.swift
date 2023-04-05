//
//  Movies.swift
//  ProMovies
//
//  Created by Jane Strashok on 13.03.2023.
//

import Foundation

struct Movie: Codable {
    //TODO: add properties
//    func encode(to encoder: Encoder) throws {
//        <#code#>
//    }
    var poster: String
    var name: String
//    var genre: String
//    var duration: String
//    var popularity: Int
    init(poster: String, name: String) {
        self.poster = poster
        self.name = name
    }
}
