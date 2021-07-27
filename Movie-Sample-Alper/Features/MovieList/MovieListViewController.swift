//
//  MovieListViewController.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import UIKit

protocol MovieListViewControllerProtocol: AnyObject {
    
    func showPopularMovies(model: MovieListBaseModel)
    func showFail(error: Error?)
}

class MovieListViewController: BaseViewController {
   
    // MARK: - Variables
    private var movieData: [MovieListModel?] = []
    private var currentPage = 1
    private var shouldRefresh = false
    private var searchResults: [MovieListModel?] = []
    private var displayedData: [MovieListModel?] = []
    
    // MARK: - Constants
    private struct Constants {
        static let cellWidthMultiplier: CGFloat = 0.425
        static let screenWidth = UIScreen.main.bounds.width
        static let cellWidth = screenWidth * Constants.cellWidthMultiplier
        static let cellHeight: CGFloat = Constants.cellWidth * 2
        static let footerHeight: CGFloat = 50
        static let collectionViewInset: CGFloat = 20
    }

    // MARK: - Outlets
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var errorView: UIView!
    
    // MARK: - Dependencies
    var interactor: MovieListInteractorProtocol?
    var presenter: MovieListPresenterProtocol?
    
    // MARK: - Initialization
    override func setup() {

        let movieListInteractor = MovieListInteractor()
        let movieListPresenter = MovieListPresenter()
        
        movieListPresenter.viewController = self
        movieListInteractor.presenter = movieListPresenter
        movieListPresenter.interactor = movieListInteractor
        interactor = movieListInteractor
        presenter = movieListPresenter
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerElements()
        presenter?.fetchMovies(pageNo: currentPage)
        showLoadingView()
    }
    
    // MARK: - SetupUI
    
    func setupUI() {
        setupCollectionViewLayout()
        searchBar.setShowsCancelButton(false, animated: true)
        errorView.isHidden = true
    }
    
    // MARK: - Setup CollectionView

    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.footerReferenceSize = CGSize(width: Constants.screenWidth, height: Constants.footerHeight)
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.collectionViewInset, bottom: 0, right:  Constants.collectionViewInset)
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.reloadData()
        collectionView.delegate = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
    
    private func registerElements() {
        MovieListCollectionViewCell.register(to: collectionView)
        LoadMoreCollectionReusableView.registerForFooter(to: collectionView)
        searchBar.delegate = self
    }
    
    // MARK: - Actions

    private func setFavorites() {
        if isSearchActive() {
            setFavouriteMoviesInSearch()
            displayedData = searchResults
            setFavouriteMovies()
        } else {
            setFavouriteMovies()
            displayedData = movieData
        }
    }
    
    private func isSearchActive() -> Bool {
        if searchResults.count == displayedData.count {
            return true
        } else {
            return false
        }
    }
    
    private func setFavouriteMoviesInSearch() {
        let defaults = UserDefaults.standard
        if let favouriteMovies = defaults.array(forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey) {
            guard let likedIds = favouriteMovies as? [Int] else { return }
            for index in searchResults.indices {
                var tempMovie = searchResults[index]
                if likedIds.contains(searchResults[index]?.id ?? 0) {
                    tempMovie?.isFavoriteMovie = true
                } else {
                    tempMovie?.isFavoriteMovie = false
                }
                searchResults[index] = tempMovie
            }
        }
    }
    
    private func setFavouriteMovies() {
        let defaults = UserDefaults.standard
        if let favouriteMovies = defaults.array(forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey) {
            guard let likedIds = favouriteMovies as? [Int] else { return }
            for index in movieData.indices {
                var tempMovie = movieData[index]
                if likedIds.contains(movieData[index]?.id ?? 0) {
                    tempMovie?.isFavoriteMovie = true
                } else {
                    tempMovie?.isFavoriteMovie = false
                }
                movieData[index] = tempMovie
            }
        }
    }
}

// MARK: - Collection View Methods

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.typeName, for: indexPath) as? MovieListCollectionViewCell else {return UICollectionViewCell()}
        
        movieCell.movieListCollectionCellData = displayedData[indexPath.item]
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let loadMoreFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadMoreCollectionReusableView.typeName, for: indexPath) as? LoadMoreCollectionReusableView else { return UICollectionReusableView() }
        loadMoreFooter.delegate = self
        loadMoreFooter.setLoadMoreButtonVisibility(isHidden: isSearchActive())
        return loadMoreFooter
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.cellWidth, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MovieDetailViewController.typeName) as? MovieDetailViewController {
            guard let movieId = displayedData[indexPath.item]?.id else {return}
            detailVC.setMovieDetailParameters(movieId: movieId, cellIndex: indexPath, delegate: self)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - Show Data

extension MovieListViewController: MovieListViewControllerProtocol {

    func showPopularMovies(model: MovieListBaseModel) {
        DispatchQueue.main.async {
            self.movieData.append(contentsOf: model.results)
            self.setFavouriteMovies()
            self.displayedData = self.movieData
            UIView.performWithoutAnimation {
                self.collectionView.reloadSections(IndexSet(integer: 0))
                self.hideLoadingView()
            }
        }
    }
    
    func showFail(error: Error?) {
       
        DispatchQueue.main.async {
            self.errorView.isHidden = false
            self.hideLoadingView()
            self.showError(error: error)
        }
    }
}

// MARK: - LoadMoreButton

extension MovieListViewController: LoadMoreDelegate {
    
    func loadMorePressed() {
        currentPage += 1
        presenter?.fetchMovies(pageNo: currentPage)
        showLoadingView()
    }
}

extension MovieListViewController: UserLikedMovie {
    func userChangedLike(likeState: Bool, cellIndex: IndexPath) {
        setFavorites()
        guard let movieCell: MovieListCollectionViewCell = collectionView.cellForItem(at: cellIndex) as? MovieListCollectionViewCell else {
            return
        }
        movieCell.movieListCollectionCellData = movieData[cellIndex.row]
        collectionView.reloadItems(at: [cellIndex])
    }
}

// MARK: - Search Bar and Keyboard

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            restoreSearchResults()
        } else {
            runSearch(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        errorView.isHidden = true
        if !isSearchActive() {
            displayedData = movieData
            collectionView.reloadData()
        }
        dismissKeyboard()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        runSearch(searchText: searchBar.text)
        dismissKeyboard()
    }
    
    func runSearch(searchText: String?) {
        searchResults = []
        if let query = searchBar.text {
            for movie in movieData {
                if let movieTitle = movie?.title?.lowercased() {
                    if movieTitle.contains(query.lowercased()) {
                        searchResults.append(movie)
                        displayedData = searchResults
                        collectionView.reloadData()
                    }
                }
            }
            if searchResults.isEmpty {
                errorView.isHidden = false
                searchBar.setShowsCancelButton(true, animated: true)
            } else {
                errorView.isHidden = true
                searchBar.setShowsCancelButton(false, animated: true)
            }
        }
    }
    
    private func restoreSearchResults() {
        errorView.isHidden = true
        searchResults = []
        displayedData = movieData
        collectionView.reloadData()
    }
}
