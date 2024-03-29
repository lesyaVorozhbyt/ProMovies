//
//  MoviesAPI.swift
//  ProMovies
//
//  Created by Jane Strashok on 13.03.2023.
//

import Foundation

enum MoviesAPI {
    case comingNow
    case comingSoon
    case movie(String)
    case castAndCrew(String)
    case reviews(String)
    
    var pass: String {
        switch self {
        case .comingNow:
            return "/movie/now_playing"
        case .comingSoon:
            return "/movie/upcoming"
        case let .movie(id):
            return "/movie/\(id)"
        case let .castAndCrew(id):
            return "/movie/\(id)/credits"
        case let .reviews(id):
            return "/movie/\(id)/reviews"
        
        }
    }
    //TODO: add logic to confirm query parameter
    var queryParameters: String {
        "?api_key=55957fcf3ba81b137f8fc01ac5a31fb5"
    }
}
