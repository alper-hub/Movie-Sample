//
//  MovieDetailListWebService.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 28.07.2021.
//

import Foundation

protocol MovieDetailWebServiceDelegate: AnyObject {
    
    func fetchedMovieDetailsSuccesFully(model: MovieDetailModel)
    func movieDetailFetchFailure(error: Error?)

}

class MovieDetailListWebService: MovieDetailNetworkDelegate {

    weak var delegate: MovieDetailWebServiceDelegate?
    private let sessionProvider = URLSessionProvider()

    func fetchMovieDetails(movieId: Int) {
        sessionProvider.request(type: MovieDetailModel.self, service: MovieService.detail(movieId: movieId)) { response in
            switch response {
            case let .success(movieDetailModel):
                self.delegate?.fetchedMovieDetailsSuccesFully(model: movieDetailModel)
            case let .failure(error):
                self.delegate?.movieDetailFetchFailure(error: error)
            }
        }
    }
}
