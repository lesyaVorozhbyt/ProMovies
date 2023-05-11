//
//  Review.swift
//  ProMovies
//
//  Created by Jane Strashok on 10.04.2023.
//

import Foundation

struct Reviews: Codable {
    var results: [Review]
    var totalResults: Int
}

struct Review: Codable {
    var authorDetails: String?
    var content: String
    var createdAt: String
}
