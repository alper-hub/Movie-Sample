//
//  MovieListInteractor.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import Foundation

protocol MovieListInteractorProtocol: AnyObject {
    func fetchPopularMovies(pageNo: Int)
}

class MovieListInteractor: MovieListInteractorProtocol  {
    
    var presenter: MovieListPresenterProtocol?
    
    func fetchPopularMovies(pageNo: Int) {
        if let url = URL(string: NetworkConstants.baseUrl + NetworkConstants.movieEndpoint + NetworkConstants.popularEndPoint + NetworkConstants.languageEndPoint + NetworkConstants.englishUs + NetworkConstants.apiKeyEndPoint + NetworkConstants.apiKey + NetworkConstants.pageEndPoint + String(pageNo)) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        
                        let parsedMovieListModel = try jsonDecoder.decode(MovieListBaseModel.self, from: data)
                        self.presenter?.presentPopularMovies(model: parsedMovieListModel)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                if let err = error {
                    self.presenter?.presentFail(error: error)
                }
            }.resume()
        }
    }
}
