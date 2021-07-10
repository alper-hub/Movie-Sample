//
//  MovieListPresenter.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import Foundation

protocol MovieListPresenterProtocol: AnyObject {
    func presentPopularMovies(model: MovieListBaseModel)
    func presentFail(error: Error?)
}

class MovieListPresenter: MovieListPresenterProtocol {

    // MARK: - Dependencies
    var viewController: MovieListViewControllerProtocol?
    
    func presentPopularMovies(model: MovieListBaseModel) {
        viewController?.showPopularMovies(model: model)
    }
    
    func presentFail(error: Error?) {
        viewController?.showFail(error: error)
    }
}
