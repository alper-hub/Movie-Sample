//
//  MovieListPresenter.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import Foundation

protocol MovieListNetworkDelegate: AnyObject {
    
    func fetchMovies(pageNumber: Int)
}

protocol MovieListViewModelDelegate: AnyObject {
    
    func moviesFetched()
    func movieFetchError(error: Error?)
    func reloadCollectionView()
}

protocol MovieListViewModelProtocol: AnyObject {
    
    var movieData: [MovieListModel?] {get set}
    var searchResults: [MovieListModel?] { get set }
    var displayedData: [MovieListModel?] { get set }
    var currentPage: Int {get set}
    
    func restoreSearch()
    func filterMoviesWithSearchText(text: String)
    func setFavorites()
    func refreshAfterCancelPressed()
    func isSearchActive() -> Bool
    func fetchPopularMovies()
}

class MovieListViewModel: MovieListViewModelProtocol {

    var movieData: [MovieListModel?]
    var searchResults: [MovieListModel?]
    var displayedData: [MovieListModel?]
    var currentPage: Int
    var webService = MovieListWebService()
    // MARK: - Dependencies
    
    weak var delegate: MovieListViewModelDelegate?
    weak var webDelegate: MovieListNetworkDelegate?
    let defaults = UserDefaults.standard

    // MARK: - Init
    
    init(delegate: MovieListViewModelDelegate?) {
        movieData = []
        searchResults = []
        displayedData = []
        self.delegate = delegate
        currentPage = 1
        webService.delegate = self
        self.webDelegate = webService
    }
    
    func setMovieData(model: MovieListBaseModel) {
        movieData.append(contentsOf: model.results)
        retrieveAndSetFavouriteMovies()
        displayedData = movieData
    }
    
     func setFavorites() {
        if isSearchActive() {
            retrieveAndSetFavouriteMoviesInSearch()
            displayedData = searchResults
            retrieveAndSetFavouriteMovies()
        } else {
            retrieveAndSetFavouriteMovies()
            displayedData = movieData
        }
    }
    
    func isSearchActive() -> Bool {
        return searchResults.count == displayedData.count
    }
    
    private func retrieveAndSetFavouriteMovies() {
        for index in movieData.indices {
            var tempMovie = movieData[index]
            if fetchFavoriteMovies().contains(movieData[index]?.movieId ?? 0) {
                tempMovie?.isFavoriteMovie = true
            } else {
                tempMovie?.isFavoriteMovie = false
            }
            movieData[index] = tempMovie
        }
    }
    
    private func retrieveAndSetFavouriteMoviesInSearch() {
        for index in searchResults.indices {
            var tempMovie = searchResults[index]
            if fetchFavoriteMovies().contains(searchResults[index]?.movieId ?? 0) {
                tempMovie?.isFavoriteMovie = true
            } else {
                tempMovie?.isFavoriteMovie = false
            }
            searchResults[index] = tempMovie
        }
    }
    
    private func fetchFavoriteMovies() -> [Int] {
        if let favouriteMovies = defaults.array(forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey) {
            guard let favoriteMovieIds = favouriteMovies as? [Int] else { return [] }
            return favoriteMovieIds
        } else {
            return []
        }
    }
    
    func refreshAfterCancelPressed() {
        displayedData = movieData
    }
    
    func restoreSearch() {
        searchResults = []
        displayedData = movieData
        delegate?.reloadCollectionView()
    }
    
    func filterMoviesWithSearchText(text: String) {
        searchResults = []
        for movie in movieData {
            if let movieTitle = movie?.title?.lowercased() {
                if movieTitle.contains(text.lowercased()) {
                    searchResults.append(movie)
                    displayedData = searchResults
                    delegate?.reloadCollectionView()
                }
            }
        }
    }
    
     func fetchPopularMovies() {
        webDelegate?.fetchMovies(pageNumber: currentPage)
    }
}

extension MovieListViewModel: MovieListWebServiceDelegate {
    
    func fetchedMoviesSuccesFully(model: MovieListBaseModel) {
        self.setMovieData(model: model)
        self.delegate?.moviesFetched()
    }
    
    func movieFetchFailure(error: Error?) {
        self.delegate?.movieFetchError(error: error)
    }
}
