//
//  MovieListModel.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import Foundation
import UIKit

struct MovieListBaseModel: Codable {
    var page: Int?
    var total_pages: Int?
    var results: [MovieListModel?]
}

struct MovieListModel: Codable {
    var title: String?
    var poster_path: String?
    var id: Int?
    var overview: String?
    var vote_count: Int?
}
