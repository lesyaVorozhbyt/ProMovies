//
//  VideoNetworkManager.swift
//  ProMovies
//
//  Created by Test on 23.04.2023.
//

import Foundation

class VideoNetworkManager {
    static let shared = VideoNetworkManager()
    private let baseURL = "https://api.themoviedb.org/3"
    var items: VideoResponse?
    
    //MARK: add id for url from movies
    func fetchRequest (movieid: String, completion: @escaping (Response<VideoResponse>) -> Void) {
        guard let url = URL(string: "\(baseURL)/movie/\(movieid)/videos?api_key=55957fcf3ba81b137f8fc01ac5a31fb5") else { return }
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
                guard let items = try? decoder.decode(VideoResponse.self, from: data) else { return }
                completion(.success(items))
                self.items = items
            } else {
                completion(.error("Sorry...again"))
            }

        }.resume()
    }
}
