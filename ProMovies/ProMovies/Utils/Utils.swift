//
//  Utils.swift
//  ProMovies
//
//  Created by Test on 20.04.2023.
//

import Foundation

struct Utils {
    static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder ()
        jsonDecoder.keyDecodingStrategy = . convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter ()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
}
