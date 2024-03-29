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
    
    func fetchComingSoonMovies(completion: @escaping (Response<MoviesResponse>) -> Void) {
        fetchRequest(MoviesAPI.comingSoon, completion: completion)
    }
    
    func fetchComingNowMovies(completion: @escaping (Response<MoviesResponse>) -> Void) {
        fetchRequest(MoviesAPI.comingNow, completion: completion)
    }
    
    func fetchMovieById (_ id: String, completion: @escaping (Response<Movie>) -> Void) {
        fetchRequest(MoviesAPI.movie(id), completion: completion)
    }
    
    func fetchCastAndCrewForMovie(_ id: String, completion: @escaping (Response<CastAndCrewMembers>) -> Void) {
        fetchRequest(MoviesAPI.castAndCrew(id), completion: completion)
    }
    
    func fetchReviewsForMovie(_ id: String, completion: @escaping (Response<Reviews>) -> Void) {
        fetchRequest(MoviesAPI.reviews(id), completion: completion)
    }
    
    private func fetchRequest<T: Codable> (_ moviesAPI: MoviesAPI, completion: @escaping (Response<T>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(moviesAPI.pass)\(moviesAPI.queryParameters)") else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.error("Sorry..."))
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            if statusCode <= 299 && statusCode >= 200 {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let items = try? decoder.decode(T.self, from: data) else {
                    completion(.error("Sorry...can't pass"))
                    return }
                completion(.success(items))
            } else {
                completion(.error("Sorry...again"))
            }

        }.resume()
    }
    
    
}

