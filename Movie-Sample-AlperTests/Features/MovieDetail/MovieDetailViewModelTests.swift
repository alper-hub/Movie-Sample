//
//  MovieDetailViewModelTests.swift
//  Movie-Sample-AlperTests
//
//  Created by Alper Tufan on 27.12.2021.
//

import XCTest
@testable import Movie_Sample_Alper

class MovieDetailViewModelTests: XCTestCase {
    
    private var sut: MovieDetailViewModel!
    private var controller: MockMovieDetailViewModelDelegate!
    private var webService: MockWebService!

    override func setUp() {
        controller = MockMovieDetailViewModelDelegate()
        webService = MockWebService()
        sut = MovieDetailViewModel(delegate: controller, currentId: MovieDetailModel.stub().movieId!, cellIndexPath: [0, 0])
        sut.webService.delegate = webService
    }
    
    override func tearDown() {
        sut = nil
    }

    func testPresentMovieDetails() {
        // When
        sut.presentMovieDetails(model: MovieDetailModel.stub())

        // Then
        XCTAssertEqual(controller.movieModel, MovieDetailModel.stub())
    }

    func testErrorShown() {
        // Given
        let error = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Invalid access token"])
        // When
        sut.presentFail(error: error)

        // Then
        XCTAssertTrue(controller.errorShown)
    }

    func testAddToFavorites() {
        // Given
        sut.movieDetailModel = MovieDetailModel.stub()

        // When
        sut.addToFavouriteMovies()
        
        // Then
        XCTAssertTrue(sut.favoriteMovies.contains(MovieDetailModel.stub().movieId!))
        XCTAssertTrue((sut.defaults.array(forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey) as? [Int])!.contains(MovieDetailModel.stub().movieId!))
        XCTAssertTrue(sut.isFavorite)
        XCTAssertTrue(controller.isFavorite)
    }

    func testRemoveFromFavorites() {
        // Given
        sut.movieDetailModel = MovieDetailModel.stub()
        sut.favoriteMovies = [MovieDetailModel.stub().movieId!]
        sut.defaults.set(sut.favoriteMovies, forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)
        
        // When
        sut.removeFromFavouriteMovies()

        // Then
        XCTAssertEqual(sut.favoriteMovies, [])
        XCTAssertEqual(sut.defaults.array(forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey) as? [Int], [])
        XCTAssertFalse(sut.isFavorite)
        XCTAssertFalse(controller.isFavorite)
    }

    func testCheckIsFavorite() {
        // Given
        sut.defaults.set([sut.currentMovieId], forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)
        
        // When
        sut.checkIsFavoriteMovie()
        
        // Then
        XCTAssertTrue(sut.isFavorite)
        XCTAssertTrue(sut.initialLikeState)
        sut.defaults.set([], forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)
    }

    func testCheckIsNotFavorite() {
        // When
        sut.checkIsFavoriteMovie()
        
        // Then
        XCTAssertFalse(sut.isFavorite)
        XCTAssertFalse(sut.initialLikeState)
    }

    func testFetchDetails() {
        // When
        sut.fetchMovieDetails()

        let expectation = self.expectation(description: "Fetch Movie Detail Web Service Expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
        
        // Then
        XCTAssertTrue(webService.success)
    }
}

private class MockMovieDetailViewModelDelegate: MovieDetailViewModelDelegate {

    var movieModel: MovieDetailModel?
    var errorShown = false
    var isFavorite = false

    func showMovieDetails(model: MovieDetailModel?) {
        self.movieModel = model
    }
    
    func showFail(error: Error?) {
        errorShown = true
    }
    
    func changeRatingStar(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}


private class MockWebService: MovieDetailWebServiceDelegate {

    var success = false
    
    func fetchedMovieDetailsSuccesFully(model: MovieDetailModel) {
        success = true
    }
    
    func movieDetailFetchFailure(error: Error?) {}
}
