//
//  MovieListModel.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import Foundation

struct MovieListModel: Decodable, Equatable {
    
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

extension MovieListModel {

    public static func stub() -> MovieListModel {
        return MovieListModel(
            title: "Spider-Man: No Way Home",
            posterPath: "/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg",
            movieId: 634649,
            isFavoriteMovie: false
        )
    }
}
