//
//  MovieDetailViewController.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import UIKit

protocol MovieDetailViewControllerProtocol: AnyObject {
    
    func showMovieDetails(model: MovieDetailModel?)
    func showFail(error: Error?)
}

protocol UserLikedMovie: AnyObject {
    func userChangedLike(likeState: Bool, cellIndex: IndexPath)
}

class MovieDetailViewController: BaseViewController {

    // MARK: - Variables
    
    private var movieId = 0
    private var userLiked = false
    private var initialLikeState = false
    private var finalLikeState = false
    private var likedMovieIds: [Int?] = []
    private var cellIndex: IndexPath?
    private weak var likedDelegate: UserLikedMovie?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var movieOverview: UILabel!
    @IBOutlet private weak var voteCountOuterView: UIView!
    @IBOutlet private weak var voteCount: UILabel!
    @IBOutlet private weak var starButton: UIBarButtonItem!
    @IBOutlet private weak var backButton: UIBarButtonItem!
    
    // MARK: - Dependencies
    
    var interactor: MovieDetailInteractorProtocol?
    var presenter: MovieDetailPresenterProtocol?
    
    // MARK: - Initialization

    override func setup() {

        let movieDetailInteractor = MovieDetailInteractor()
        let movieDetailPresenter = MovieDetailPresenter()
        
        movieDetailPresenter.viewController = self
        movieDetailInteractor.presenter = movieDetailPresenter
        movieDetailPresenter.interactor = movieDetailInteractor
        interactor = movieDetailInteractor
        presenter = movieDetailPresenter
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initialLikeState = userLiked
        showLoadingView()
        presenter?.fetchMovieDetails(movieId: movieId)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        finalLikeState = userLiked
        if let indexPath = cellIndex {
            likedDelegate?.userChangedLike(likeState: didLikeChange(), cellIndex: indexPath)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func starButtonPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if userLiked {
            userLiked = false
            starButton.image = UIImage(systemName: MovieAppGlobalConstants.starIcon)
            if let favouriteMovies = defaults.array(forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)  {
                guard let likedIds: [Int] = favouriteMovies as? [Int] else {return}
                var temporaryArray = likedIds
                if let index = likedIds.firstIndex(of: (movieId)) {
                    temporaryArray.remove(at: index)
                    defaults.set(temporaryArray, forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)
                }
            }
        } else {
            userLiked = true
            starButton.image = UIImage(systemName: MovieAppGlobalConstants.filledStarIcon)

            if var favouriteMovies = defaults.array(forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey) {
                favouriteMovies.append(movieId as Any)
                defaults.set(favouriteMovies, forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)
            } else {
                likedMovieIds.append(movieId)
                defaults.setValue(likedMovieIds, forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey)
            }
        }
    }
    
    func setMovieDetailParameters(movieId: Int, cellIndex: IndexPath, delegate: UserLikedMovie?) {
        self.movieId = movieId
        self.cellIndex = cellIndex
        likedDelegate = delegate
    }
    
    // MARK: - SetupUI

    private func setupUI() {
        voteCountOuterView.setRounded()
        determineLiked()
    }
    
    private func determineLiked() {
        let defaults = UserDefaults.standard
        if let favouriteMovies = defaults.array(forKey: MovieAppGlobalConstants.favouriteMoviesArrayKey) {
            guard let likedIds = favouriteMovies as? [Int] else {return}
            if likedIds.contains(movieId) {
                self.userLiked = true
                starButton.image = UIImage(systemName: MovieAppGlobalConstants.filledStarIcon)
            }
        }
    }
        
    private func didLikeChange() -> Bool {
        if initialLikeState == finalLikeState {
            return false
        } else {
            return true
        }
    }
}

extension MovieDetailViewController: MovieDetailViewControllerProtocol {
    
    func showMovieDetails(model: MovieDetailModel?) {
            if let imagePath = model?.poster_path {
                if let imageUrl = URL(string: NetworkConstants.bigImageURL + imagePath) {
                    self.movieImage.loadImage(url: imageUrl, placeholder: UIImage(named: MovieAppGlobalConstants.placeholderMovieIcon))
                }
            }
            DispatchQueue.main.async {
                self.movieTitle.text = model?.title
                self.movieOverview.text = model?.overview
                self.voteCount.text = String(model?.vote_count ?? 0)
                self.hideLoadingView()
            }
        }
    
    func showFail(error: Error?) {
        DispatchQueue.main.async {
            self.hideLoadingView()
            self.showError(error: error)
        }
    }
}
