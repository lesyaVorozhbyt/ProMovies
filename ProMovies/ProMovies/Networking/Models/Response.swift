//
//  Response.swift
//  ProMovies
//
//  Created by Jane Strashok on 13.03.2023.
//

import Foundation

enum Response<T> {
    case success(T)
    case error(String)
}
