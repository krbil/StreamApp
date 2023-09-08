//
//  Network.swift
//  StreamFlexSystems
//
//  Created by Илья Крылов on 08.09.2023.
//

import Foundation


class Network {
    
    static let shared = Network()
    
    private let apiKey = "d2bc56bb74d10fcca04542127ebda98c"
    
    func fetchAllPopularMovies(page: Int, completion: @escaping (Result?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?page=\(page)&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(nil, error)
            }
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                completion(result, nil)
        
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func fetchMoviesOnAir(page: Int, completion: @escaping (Result?, Error?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?page=\(page)&api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(nil, error)
            }
            guard let data = data else { return }
            
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                completion(result, nil)
        
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
