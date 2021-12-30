//
//  MovieDetailModel.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 26.07.2021.
//

import Foundation

struct MovieDetailModel: Decodable, Equatable {
    
    var title: String?
    var posterPath: String?
    var overview: String?
    var voteCount: Int?
    var movieId: Int?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case title
        case overview
        case voteCount = "vote_count"
        case movieId = "id"
    }
}

extension MovieDetailModel {

    public static func stub() -> MovieDetailModel {
        return MovieDetailModel(
            title: "Spider-Man: No Way Home",
            posterPath: "/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg",
            overview: "Peter Parker is unmasked and no longer able to separate his normal          life from the high-stakes of being a super-hero. When he asks for           help from Doctor Strange the stakes become even more dangerous,             forcing him to discover what it truly means to be Spider-Man.",
            voteCount: 2594,
            movieId: 634649
        )
    }
}
