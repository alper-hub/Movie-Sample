//
//  MovieListViewController.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import UIKit

protocol MovieListViewControllerProtocol: AnyObject {
    
    func showPopularMovies(model: MovieListBaseModel)
}

class MovieListViewController: BaseViewController {
   
    // MARK: - Variables
    
    var movieListData: MovieListBaseModel?
    var movieData: [MovieListModel?] = []
    var loadMoreFooter = LoadMoreCollectionReusableView()
    var currentPage = 1
    var shouldRefresh = false
    var searchResults: [MovieListModel?] = []
    var displayedData: [MovieListModel?] = []
    // MARK: - Constants
    
    private struct Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static let cellWidth = screenWidth * 0.425
        static let cellHeight = cellWidth * 2
    }

    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    
    // MARK: - Dependencies
    var interactor: MovieListInteractorProtocol?
    
    // MARK: - Initialization

    override func setup() {

        let movieListInteractor = MovieListInteractor()
        let movieListlPresenter = MovieListPresenter()
        
        movieListlPresenter.viewController = self
        movieListInteractor.presenter = movieListlPresenter
        self.interactor = movieListInteractor
    }
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldRefresh {
            collectionView.reloadData()
        } 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchPopularMovies(pageNo: currentPage)
        setupCollectionViewLayout()
        registerElements()
        searchBar.setShowsCancelButton(false, animated: true)
        errorView.isHidden = true
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        setupCollectionViewLayout()
        
    }

    
    // MARK: - Setup CollectionView

    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = layout
        self.collectionView.isPrefetchingEnabled = true
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        self.collectionView.delegate = self
        self.collectionView.prefetchDataSource = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
    
    func registerElements() {
        let cell = UINib(nibName: "MovieListCollectionViewCell", bundle: nil)
        collectionView.register(cell, forCellWithReuseIdentifier: "MovieListCollectionViewCell")
        
        let footer = UINib(nibName: "LoadMoreCollectionReusableView", bundle: nil)
        self.collectionView.register(footer, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadMoreCollectionReusableView")
        searchBar.delegate = self

    }
    
    func determineLiked(id: Int?) -> Bool {
        let defaults = UserDefaults.standard
        if let likedMovies = defaults.array(forKey: "likedMovieIds") {
            let likedIds = likedMovies as! [Int]
            if likedIds.contains(id ?? 0) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}

// MARK: - Collection View Methods

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionViewCell", for: indexPath) as! MovieListCollectionViewCell
        movieCell.movieListCollectionCellData = displayedData[indexPath.item]
        if determineLiked(id: displayedData[indexPath.item]?.id) {
            movieCell.starOuterView.isHidden = false
        } else {
            movieCell.starOuterView.isHidden = true

        }
        return movieCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
            loadMoreFooter = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadMoreCollectionReusableView", for: indexPath) as! LoadMoreCollectionReusableView
        loadMoreFooter.delegate = self
            return loadMoreFooter
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let size : CGSize = CGSize.init(width: Constants.screenWidth, height: 50)
        return size
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.cellWidth, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: Constants.screenWidth * 0.05, bottom: 0 , right: Constants.screenWidth * 0.05)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController {
            detailVC.movieData = displayedData[indexPath.item]
            detailVC.likedDelegate = self
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - Show Data

extension MovieListViewController: MovieListViewControllerProtocol {
    
    func showPopularMovies(model: MovieListBaseModel) {
        DispatchQueue.main.async {
            self.movieListData = model
            self.movieData.append(contentsOf: model.results)
            self.displayedData = self.movieData
            self.collectionView.reloadData()
        }
    }
}

extension MovieListViewController: LoadMoreDelegate {
    
    func loadMorePressed() {
        currentPage += 1
        interactor?.fetchPopularMovies(pageNo: currentPage)
    }
}

extension MovieListViewController: UserLikedMovie {
    func userChangedLike(likeState: Bool) {
        shouldRefresh = likeState
    }
}

// MARK: - Search Bar and Keyboard

extension MovieListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
        searchBar.text = ""
        displayedData = movieData
        collectionView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
                for movie in movieData {
                    if let movieTitle = movie?.title {
                        if movieTitle.contains(query) {
                            searchResults.append(movie)
                        }
                    }
                }
        }
        displayedData = searchResults
        collectionView.reloadData()
        dismissKeyboard()
        searchBar.setShowsCancelButton(false, animated: true)
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)

    }
}
