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
   
    weak var delegate: MovieListWebServiceDelegate?
    
    func fetchMovies(pageNumber: Int) {
        if let url = URL(string: NetworkConstants.baseUrl + NetworkConstants.movieEndpoint + NetworkConstants.popularEndPoint + NetworkConstants.languageEndPoint + NetworkConstants.englishUs + NetworkConstants.apiKeyEndPoint + NetworkConstants.apiKey + NetworkConstants.pageEndPoint + String(pageNumber)) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedMovieListModel = try jsonDecoder.decode(MovieListBaseModel.self, from: data)
                        self.delegate?.fetchedMoviesSuccesFully(model: parsedMovieListModel)
                    } catch {
                        self.delegate?.movieFetchFailure(error: error)
                    }
                }
                if let networkError = error {
                    self.delegate?.movieFetchFailure(error: networkError)
                }
            }.resume()
        }
    }
}
