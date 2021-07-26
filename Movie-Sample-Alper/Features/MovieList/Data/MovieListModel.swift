//
//  MovieListModel.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import Foundation

struct MovieListModel: Codable {
    var title: String?
    var poster_path: String?
    var id: Int?
    var overview: String?
    var vote_count: Int?
}
