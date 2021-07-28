//
//  MovieListBaseModel.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 26.07.2021.
//

import Foundation

struct MovieListBaseModel: Decodable {
    var page: Int?
    var totalPages: Int?
    var results: [MovieListModel?]
   
    enum CodingKeys: String, CodingKey {
        case totalPages = "total_pages"
        case page
        case results
    }
}


