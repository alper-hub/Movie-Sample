//
//  MovieListBaseModel.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 26.07.2021.
//

import Foundation

struct MovieListBaseModel: Decodable {
    
    var page: Int?
    var results: [MovieListModel?]
}

extension MovieListBaseModel {
    
    public static func stub() -> MovieListBaseModel {
        return MovieListBaseModel(
            page: 1,
            results: [
                MovieListModel(
                    title: "Spider-Man: No Way Home",
                    posterPath: "/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg",
                    movieId: 634649,
                    isFavoriteMovie: nil
                ),
                MovieListModel(
                    title: "Incredibles",
                    posterPath: "/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg",
                    movieId: 634648,
                    isFavoriteMovie: nil
                ),
                MovieListModel(
                    title: "Matrix",
                    posterPath: "/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg",
                    movieId: 634647,
                    isFavoriteMovie: nil
                )
            ]
        )
    }
}
