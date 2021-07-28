//
//  MovieListViewController.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import UIKit

class MovieListViewController: BaseViewController {
   
    // MARK: - Variables
    
    private var viewModel: MovieListViewModelProtocol?
    
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
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieListViewModel(delegate: self)
        setupUI()
        registerElements()
        viewModel?.fetchPopularMovies()
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
    


}

// MARK: - Collection View Methods

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.displayedData.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieListCollectionViewCell.typeName, for: indexPath) as? MovieListCollectionViewCell else {return UICollectionViewCell()}
        
        movieCell.movieListCollectionCellData = viewModel?.displayedData[indexPath.item]
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let loadMoreFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadMoreCollectionReusableView.typeName, for: indexPath) as? LoadMoreCollectionReusableView else { return UICollectionReusableView() }
        loadMoreFooter.delegate = self
        loadMoreFooter.setLoadMoreButtonVisibility(isHidden: viewModel?.isSearchActive() ?? false)
        return loadMoreFooter
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.cellWidth, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: MovieDetailViewController.typeName) as? MovieDetailViewController {
            guard let movieId = viewModel?.displayedData[indexPath.item]?.movieId else {return}
            detailVC.setMovieDetailParameters(movieId: movieId, cellIndex: indexPath, delegate: self)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}


// MARK: - LoadMoreButton

extension MovieListViewController: LoadMoreDelegate {
    
    func loadMorePressed() {
        viewModel?.currentPage += 1
        viewModel?.fetchPopularMovies()
        showLoadingView()
    }
}

extension MovieListViewController: UserLikedMovie {
    func userChangedLike(likeState: Bool, cellIndex: IndexPath) {
        viewModel?.setFavorites()
        guard let movieCell: MovieListCollectionViewCell = collectionView.cellForItem(at: cellIndex) as? MovieListCollectionViewCell else {
            return
        }
        movieCell.movieListCollectionCellData = viewModel?.movieData[cellIndex.row]
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
        viewModel?.refreshAfterCancelPressed()
        collectionView.reloadData()
        
        dismissKeyboard()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        runSearch(searchText: searchBar.text)
        dismissKeyboard()
    }
    
    func runSearch(searchText: String?) {
        if let query = searchBar.text {
            viewModel?.filterMoviesWithSearchText(text: query)
            if let searchedMovies = viewModel?.searchResults {
                if searchedMovies.isEmpty {
                    errorView.isHidden = false
                    searchBar.setShowsCancelButton(true, animated: true)
                } else {
                    errorView.isHidden = true
                }
            } else {
                errorView.isHidden = false
            }
        }
    }
    
    private func restoreSearchResults() {
        viewModel?.restoreSearch()
        errorView.isHidden = true
    }
}

// MARK: - Show Data

extension MovieListViewController: MovieListViewModelDelegate {
   
    func reloadCollectionView() {
        collectionView.reloadData()
    }
   
    func moviesFetched() {
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.collectionView.reloadSections(IndexSet(integer: 0))
                self.hideLoadingView()
            }
        }
    }
    
    func movieFetchError(error: Error?) {
        DispatchQueue.main.async {
            self.errorView.isHidden = false
            self.hideLoadingView()
            self.showError(error: error)
        }
    }
    
}
