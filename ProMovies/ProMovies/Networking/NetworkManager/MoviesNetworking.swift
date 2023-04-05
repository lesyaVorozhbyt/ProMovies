//
//  NMProtocol.swift
//  ProMovies
//
//  Created by Jane Strashok on 13.03.2023.
//

import Foundation

protocol MoviesNetworking {
    
    func fetchComingNowMovies(completion: @escaping (Response<[Movie]>) -> Void)
    
    func fetchComingSoonMovies(completion: @escaping (Response<[Movie]>) -> Void)
}
