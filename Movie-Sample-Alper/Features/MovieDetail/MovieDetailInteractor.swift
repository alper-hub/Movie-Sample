//
//  MovieDetailInteractor.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import Foundation

protocol MovieDetailInteractorProtocol: AnyObject {
    func fetchMovieDetails(movieId: Int)
}

class MovieDetailInteractor: MovieDetailInteractorProtocol  {
    
    var presenter: MovieDetailPresenterProtocol?
    
    func fetchMovieDetails(movieId: Int) {
        if let url = URL(string: NetworkConstants.baseUrl + NetworkConstants.movieEndpoint + "/" + String(movieId) + NetworkConstants.languageEndPoint + NetworkConstants.englishUs + NetworkConstants.apiKeyEndPoint + NetworkConstants.apiKey) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        
                        let parsedMovieListModel = try jsonDecoder.decode(MovieDetailModel.self, from: data)
                        self.presenter?.presentMovieDetails(model: parsedMovieListModel)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if let err = error {
                    self.presenter?.presentFail(error: err)
                }
            }.resume()
        }
    }
}
