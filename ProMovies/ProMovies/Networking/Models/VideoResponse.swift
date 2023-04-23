//
//  Video.swift
//  ProMovies
//
//  Created by Test on 03.04.2023.
//

import UIKit
struct VideoResponse: Codable {
    let id: Int
    let results: [Video]
}

struct Video: Codable {
    let name: String
    let key: String
    let site: String
    let id: String
}


