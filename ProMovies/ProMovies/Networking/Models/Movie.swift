//
//  Movies.swift
//  ProMovies
//
//  Created by Jane Strashok on 13.03.2023.
//

import Foundation

struct Movie: Codable {
//    //TODO: add properties
////    func encode(to encoder: Encoder) throws {
////    }
//    var poster_path: String
//    var original_title: String
    var poster: String
    var title: String
    var genreIds: [Int]?
////    var duration: String
////    var popularity: Int
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        poster = try container.decode(String.self, forKey: .poster)
        genreIds = try container.decode([Int]?.self, forKey: .genreIds)

    }
    
}

struct Genre: Codable{
    var id: Int
    var name: String
    
}



extension Movie {
    enum CodingKeys: String, CodingKey {
        case poster = "poster_path"
        case title = "original_title"
        case genreIds = "genre_ids"
        }
}
