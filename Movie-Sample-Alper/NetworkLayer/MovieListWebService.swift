//
//  MovieDetailWebService.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 28.07.2021.
//

import Foundation

protocol MovieListWebServiceDelegate: AnyObject {
    
    func fetchedMoviesSuccesFully(model: MovieListBaseModel)
    func movieFetchFailure(error: Error?)

}

class MovieListWebService: MovieListNetworkDelegate {
    
    private let sessionProvider = URLSessionProvider()
    weak var delegate: MovieListWebServiceDelegate?
    
    func fetchMovies(pageNumber: Int) {
        sessionProvider.request(type: MovieListBaseModel.self, service: MovieService.list(pageNumber: pageNumber)) { response in
            switch response {
            case let .success(movieBaseModel):
                self.delegate?.fetchedMoviesSuccesFully(model: movieBaseModel)
            case let .failure(error):
                self.delegate?.movieFetchFailure(error: error)
            }
        }
    }
}
