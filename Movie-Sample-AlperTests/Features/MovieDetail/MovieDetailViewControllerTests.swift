//
//  MovieDetailViewControllerTests.swift
//  Movie-Sample-AlperTests
//
//  Created by Alper Tufan on 27.12.2021.
//

import XCTest
@testable import Movie_Sample_Alper

class MovieDetailViewControllerTests: XCTestCase {

    private var sut: MovieDetailViewController!
    private var viewModel: MockMovieDetailViewModel!
    
    override func setUp() {
        viewModel = MockMovieDetailViewModel()
        sut = MovieDetailViewController()
        sut.viewModel = viewModel
    }

    override func tearDown() {
        viewModel = nil
        sut = nil
    }
}

private class MockMovieDetailViewModel: MovieDetailViewModelProtocol {

    var isFavorite = false
    
    var cellIndex: IndexPath?
    
    var currentMovieId = 0
    
    var finalLikeState = false
    
    var initialLikeState = false
    
    func presentMovieDetails(model: MovieDetailModel?) {
        
    }
    
    func presentFail(error: Error?) {
        
    }
    
    func fetchMovieDetails() {
        
    }
    
    func addToFavouriteMovies() {
        
    }
    
    func removeFromFavouriteMovies() {
        
    }
    
    func checkIsFavoriteMovie() {
        
    }
}
