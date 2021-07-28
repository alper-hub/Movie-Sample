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
    
    func fetchMovieDetails(movieId: Int) {
        if let url = URL(string: NetworkConstants.baseUrl + NetworkConstants.movieEndpoint + "/" + String(movieId) + NetworkConstants.languageEndPoint + NetworkConstants.englishUs + NetworkConstants.apiKeyEndPoint + NetworkConstants.apiKey) {
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        
                        let parsedMovieListModel = try jsonDecoder.decode(MovieDetailModel.self, from: data)
                        self.delegate?.fetchedMovieDetailsSuccesFully(model: parsedMovieListModel)
                        
                    } catch {
                        self.delegate?.movieDetailFetchFailure(error: error)
                    }
                }
                if let networkError = error {
                    self.delegate?.movieDetailFetchFailure(error: networkError)
                }
            }.resume()
        }
    }
}
