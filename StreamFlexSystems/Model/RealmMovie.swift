//
//  RealmMovie.swift
//  StreamFlexSystems
//
//  Created by Илья Крылов on 08.09.2023.
//

import Foundation
import RealmSwift

class MovieObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var popularity: Double = 0.0
    @objc dynamic var title: String = ""
    @objc dynamic var posterPath: String = ""

    convenience init(movie: Movie) {
        self.init()
        self.id = movie.id
        self.popularity = movie.popularity
        self.title = movie.title
        self.posterPath = movie.posterPath
    }
}
