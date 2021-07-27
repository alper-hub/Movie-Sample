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
    func fetchMovies(pageNo: Int)
}

class MovieListPresenter: MovieListPresenterProtocol {

    // MARK: - Dependencies
    var viewController: MovieListViewControllerProtocol?
    var interactor: MovieListInteractorProtocol?

    func fetchMovies(pageNo: Int) {
        interactor?.fetchPopularMovies(pageNo: pageNo)
    }
    
    func presentPopularMovies(model: MovieListBaseModel) {
        viewController?.showPopularMovies(model: model)
    }
    
    func presentFail(error: Error?) {
        viewController?.showFail(error: error)
    }
}
