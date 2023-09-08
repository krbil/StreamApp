//
//  RealmManager.swift
//  StreamFlexSystems
//
//  Created by Илья Крылов on 08.09.2023.
//

import Foundation
import RealmSwift


class RealmManager {
    
    static let shared = RealmManager()
    
    private let realm = try! Realm()
    
    func getFavoritesMovies() -> [Movie] {
        let favoriteMovieObjects = realm.objects(MovieObject.self)
        var favoriteMovies = [Movie]()
        for movieObject in favoriteMovieObjects {
            let favoriteMovie = Movie(id: movieObject.id, popularity: movieObject.popularity, title: movieObject.title, posterPath: movieObject.posterPath)
            favoriteMovies.append(favoriteMovie)
        }
        
        return favoriteMovies
    }
    
    func addToFavorites(movie: Movie) {
        do {
            let movieObject = MovieObject(movie: movie)
            
            try realm.write {
                realm.add(movieObject)
            }
        } catch {
            print("Error saving movie to Realm: \(error)")
        }
    }
    
    func removeFromFavorites(movie: Movie) {
        do {
            
            try realm.write {
                realm.delete(realm.objects(MovieObject.self).filter("id == %d", movie.id))
            }
        } catch {
            print("Error deleting movie from Realm: \(error)")
        }
    }
    
    func isMovieInFavorites(movieID: Int) -> Bool {
        let predicate = NSPredicate(format: "id == %d", movieID)
        let existingMovie = realm.objects(MovieObject.self).filter(predicate).first
        return existingMovie != nil
    }
}

