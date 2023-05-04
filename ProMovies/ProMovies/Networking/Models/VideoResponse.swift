//
//  Video.swift
//  ProMovies
//
//  Created by Test on 03.04.2023.
//

import UIKit
struct VideoResponse: Codable {
    var id: Int
    var results: [Video]
}

struct Video: Codable {
    var name: String
    var key: String
    var site: String
    var id: String
}


