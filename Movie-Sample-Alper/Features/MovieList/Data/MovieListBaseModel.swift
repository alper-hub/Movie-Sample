//
//  MovieListBaseModel.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 26.07.2021.
//

import Foundation

struct MovieListBaseModel: Decodable {
    var page: Int?
    var total_pages: Int?
    var results: [MovieListModel?]
}
