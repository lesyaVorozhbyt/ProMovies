//
//  Genre.swift
//  ProMovies
//
//  Created by Lera Cuk on 20.04.2023.
//

import UIKit

class Genres {
    
    var genres: [Int: String] = [:]
    
    func fetchGenres(){
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=55957fcf3ba81b137f8fc01ac5a31fb5"
        if let url = URL(string: urlString) {
            // Створюємо URLSession
            let session = URLSession.shared
            // Створюємо data task для виконання запиту
            let task = session.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        // Розпарсюємо відповідь в форматі JSON
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        // Отримуємо масив жанрів з JSON
                        if let genresData = json?["genres"] as? [[String: Any]] {
                            for genreData in genresData {
                                // Отримуємо id та назву жанру
                                let id = genreData["id"] as? Int
                                let name = genreData["name"] as? String
                                // Додаємо жанр до словника
                                if let id = id, let name = name {
                                    self.genres[id] = name
                                }
                            }
                        }
                    } catch {
                        print("Помилка розпарсювання JSON: \(error.localizedDescription)")
                    }
                }
            }
            // Запускаємо data task
            task.resume()
        }
    }
    
    
    
    func getGenreNames( for genreIds: [Int], from genres: [Int:String]) -> String?{
        var genreNames: [String] = []
        for genreId in genreIds {
            if let genreName = genres[genreId]{
                genreNames.append(genreName)
            }
        }
        return genreNames.first
    }
}
