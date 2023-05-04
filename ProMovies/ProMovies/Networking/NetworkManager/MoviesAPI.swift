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
    //MARK: check movieID
    var pass: String {
        switch self {
        case .comingNow:
            return "/movie/now_playing"
        case .comingSoon:
            return "/movie/upcoming"
        }
    }
    //TODO: add logic to confirm query parameter
    var queryParameters: String {
        "?api_key=55957fcf3ba81b137f8fc01ac5a31fb5"
    }
}
