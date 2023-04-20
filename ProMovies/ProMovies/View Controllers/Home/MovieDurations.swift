//
//  MovieDurations.swift
//  ProMovies
//
//  Created by Lera Cuk on 20.04.2023.
//

import UIKit

struct MovieDetails: Codable {
    var duration: Int?
    var idDetails: Int
    
    enum CodingKeys: String, CodingKey {
        case duration = "runtime"
        case idDetails = "id"
    }
}

class MovieDurations{
    
    var movieDurations: [Int: Int] = [:]
    
    func fetchMovieDuration(for movie: Movie, completion: @escaping (Result<Int, Error>) -> Void) {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movie.id)?api_key=55957fcf3ba81b137f8fc01ac5a31fb5") else {
                return completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            }
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                    return
                }
                if statusCode <= 299 && statusCode >= 200 {
                    guard let data = data else {
                        completion(.failure(NSError(domain: "Invalid data", code: 0, userInfo: nil)))
                        return
                    }
                    let decoder = JSONDecoder()
                    guard let movieDetails = try? decoder.decode(MovieDetails.self, from: data) else {
                        completion(.failure(NSError(domain: "Invalid data format", code: 0, userInfo: nil)))
                        return
                    }
                    completion(.success(movieDetails.duration!))
                } else {
                    completion(.failure(NSError(domain: "Invalid status code", code: statusCode, userInfo: nil)))
                }

            }.resume()
        }
    
    func updateMovieDurations(for movies: [Movie]) async {
        await withCheckedContinuation { continuation in
            var items = movies.count
            for movie in movies {
                fetchMovieDuration(for: movie) { result in
                    switch result {
                    case .success(let duration):
                        DispatchQueue.main.async {
                            self.movieDurations[movie.id] = duration // Update the movieDurations dictionary
                        }
                        
                    case .failure(let error):
                        print("Error fetching duration for movie \(movie.title): \(error.localizedDescription)")
                    }
                    items -= 1
                    if items < 1 {
//                        DispatchQueue.main.async {
//                            self.collectionView.reloadData()
//                        }
                        continuation.resume(returning: Void())
                    }
                }
            }
        }
        
    }
}
