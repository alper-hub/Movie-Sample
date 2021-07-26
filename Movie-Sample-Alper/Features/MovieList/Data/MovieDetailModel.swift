//
//  MovieDetailModel.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 26.07.2021.
//

import Foundation

struct MovieDetailModel: Decodable {
    var title: String?
    var poster_path: String?
    var overview: String?
    var vote_count: Int?
    var id: Int?

}
