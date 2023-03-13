//
//  MoviesNetworkManager.swift
//  ProMovies
//
//  Created by Jane Strashok on 13.03.2023.
//

import Foundation

class MoviesNetworkManager: MoviesNetworking {
    
    static let shared = MoviesNetworkManager()
    private let baseURL = "https://api.themoviedb.org/3"
    
    func fetchComingSoonMovies(completion: @escaping (Response<[Movie]>) -> Void) {
        fetchRequest(MoviesAPI.comingSoon, completion: completion)
    }
    
    func fetchComingNowMovies(completion: @escaping (Response<[Movie]>) -> Void) {
        fetchRequest(MoviesAPI.comingNow, completion: completion)
    }

    
    private func fetchRequest (_ moviesAPI: MoviesAPI, completion: @escaping (Response<[Movie]>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(moviesAPI.pass)\(moviesAPI.queryParameters)") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.error("Sorry..."))
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            if statusCode <= 299 && statusCode >= 200 {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                guard let movies = try? decoder.decode([Movie].self, from: data) else { return }
                completion(.success(movies))
            } else {
                completion(.error("Sorry...again"))
            }

        }.resume()
    }
}

