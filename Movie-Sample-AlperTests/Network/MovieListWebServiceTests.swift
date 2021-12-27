//
//  MovieListWebServiceTests.swift
//  Movie-Sample-AlperTests
//
//  Created by Alper Tufan on 26.12.2021.
//

import XCTest
@testable import Movie_Sample_Alper

class MovieListWebServiceTests: XCTestCase {

    var sut: MovieListWebService!
    var controller: MockMovieListWebServiceDelegate!
    
    override func setUp() {
        sut = MovieListWebService()
        controller = MockMovieListWebServiceDelegate()
        sut.delegate = controller
    }

    func testFetchMoviesSuccess() {
        sut.fetchMovies(pageNumber: 1)
    }
}

class MockMovieListWebServiceDelegate: MovieListWebServiceDelegate {
    
    func fetchedMoviesSuccesFully(model: MovieListBaseModel) {
        
    }
    
    func movieFetchFailure(error: Error?) {
        
    }
}
