//
//  MovieListModel.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import Foundation

struct MovieListModel: Decodable {
    
    var title: String?
    var posterPath: String?
    var movieId: Int?
    var isFavoriteMovie: Bool?
    
    enum CodingKeys: String, CodingKey {
        case movieId = "id"
        case title
        case posterPath = "poster_path"
    }
}
