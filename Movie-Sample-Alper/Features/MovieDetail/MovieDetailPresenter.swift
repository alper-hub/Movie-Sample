//
//  MovieDetailPresenter.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import Foundation

protocol MovieDetailPresenterProtocol: AnyObject {
    func presentMovieDetails(model: MovieDetailModel?)
    func presentFail(error: Error?)
    func fetchMovieDetails(movieId: Int)
}

class MovieDetailPresenter: MovieDetailPresenterProtocol {

    // MARK: - Dependencies
    var viewController: MovieDetailViewControllerProtocol?
    var interactor: MovieDetailInteractorProtocol?

    func presentMovieDetails(model: MovieDetailModel?) {
        viewController?.showMovieDetails(model: model)
    }
    
    func presentFail(error: Error?) {
        
    }
    
    func fetchMovieDetails(movieId: Int) {
        interactor?.fetchMovieDetails(movieId: movieId)
    }
}
