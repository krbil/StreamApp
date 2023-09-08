//
//  Movie.swift
//  StreamFlexSystems
//
//  Created by Илья Крылов on 08.09.2023.
//

import Foundation

struct Result: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let popularity: Double
    let title: String
    let posterPath: String

    enum CodingKeys: String, CodingKey {
        case id, popularity, title
        case posterPath = "poster_path"
    }
}
