//
//  MovieListViewModelTests.swift
//  Movie-Sample-AlperTests
//
//  Created by Alper Tufan on 27.12.2021.
//

import XCTest
@testable import Movie_Sample_Alper

class MovieListViewModelTests: XCTestCase {

    private var sut: MovieListViewModel!
    private var controller: MockMovieListViewModelDelegate!
    private var webService: MockWebService!

    override func setUp() {
        controller = MockMovieListViewModelDelegate()
        webService = MockWebService()
        sut = MovieListViewModel(delegate: controller)
        sut.webService.delegate = webService
    }
    
    override func tearDown() {
        sut = nil
    }

    func testFetchPopularMovies() {
        // When
        sut.fetchPopularMovies()
        
        let expectation = self.expectation(description: "Fetch Popular Movies Web Service Expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
        
        // Then
        XCTAssertTrue(webService.movieFetchSuccess)
    }

    func testFilterMoviesWithSearchResults() {
        // Given
        sut.movieData = MovieListBaseModel.stub().results
    
        // When
        sut.filterMoviesWithSearchText(text: "sp")
        
        // Then
        XCTAssertEqual(sut.displayedData, [MovieListBaseModel.stub().results[0]])
    }

    func testRestoreSearch() {
        // Given
        sut.movieData = MovieListBaseModel.stub().results
        
        // When
        sut.restoreSearch()

        // Then
        XCTAssertEqual(sut.searchResults, [])
        XCTAssertEqual(sut.displayedData, sut.movieData)
        XCTAssertTrue(controller.reloadedCollectionView)
    }

    func testRefreshAfterCancelPressed() {
        // Given
        sut.movieData = MovieListBaseModel.stub().results
        
        // When
        sut.refreshAfterCancelPressed()

        // Then
        XCTAssertEqual(sut.displayedData, sut.movieData)
    }

    func testIsSearchActive() {
        // Given
        sut.displayedData = MovieListBaseModel.stub().results
        sut.searchResults = MovieListBaseModel.stub().results

        // Then
        XCTAssertTrue(sut.isSearchActive())

        // Given
        sut.searchResults.removeAll()

        // Then
        XCTAssertFalse(sut.isSearchActive())
    }

    func testSetFavorites() {
        // Given
        sut.displayedData = MovieListBaseModel.stub().results
        sut.searchResults = MovieListBaseModel.stub().results
        sut.defaults.set([MovieListBaseModel.stub().results[0]?.movieId], forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)
        
        // When
        sut.setFavorites()
        
        // Then
        XCTAssertTrue((sut.displayedData[0]?.isFavoriteMovie)!)

        // Given
        sut.searchResults.removeAll()
        sut.movieData = MovieListBaseModel.stub().results

        // When
        sut.setFavorites()
        
        // Then
        XCTAssertTrue((sut.displayedData[0]?.isFavoriteMovie)!)
    }

    func testSetMovieData() {
        // Given
        sut.movieData.removeAll()

        // When
        sut.setMovieData(model: MovieListBaseModel.stub())
    
        // Then
        XCTAssertTrue((sut.displayedData[0]?.isFavoriteMovie)!)
        XCTAssertEqual(sut.displayedData, sut.movieData)
    }
}

private class MockMovieListViewModelDelegate: MovieListViewModelDelegate {
    
    var reloadedCollectionView = false

    func moviesFetched() {
    }
    
    func movieFetchError(error: Error?) {
    }
    
    func reloadCollectionView() {
        reloadedCollectionView = true
    }
}

private class MockWebService: MovieListWebServiceDelegate {

    var movieFetchSuccess = false

    func fetchedMoviesSuccesFully(model: MovieListBaseModel) {
        movieFetchSuccess = true
    }
    
    func movieFetchFailure(error: Error?) {
    }
}
