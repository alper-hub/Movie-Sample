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
    var webService: MockMovieListWebServiceDelegate!
    
    override func setUp() {
        sut = MovieListWebService()
        webService = MockMovieListWebServiceDelegate()
        sut.delegate = webService
    }

    func testFetchMoviesSuccess() {
        // When
        sut.fetchMovies(pageNumber: 1)

        let expectation = self.expectation(description: "Fetch Movie Detail Web Service Success Expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
        
        // Then
        XCTAssertTrue(webService.success)
    }

    func testFetchMoviesFailure() {
        // When
        sut.fetchMovies(pageNumber: -1)

        let expectation = self.expectation(description: "Fetch Movie Detail Web Service Failure Expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
        
        // Then
        XCTAssertFalse(webService.success)
    }
}

class MockMovieListWebServiceDelegate: MovieListWebServiceDelegate {
    
    var success = false
    
    func fetchedMoviesSuccesFully(model: MovieListBaseModel) {
        success = true
    }
    
    func movieFetchFailure(error: Error?) {
        success = false
    }
}
