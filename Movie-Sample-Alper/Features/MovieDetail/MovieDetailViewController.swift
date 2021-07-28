//
//  MovieDetailViewController.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import UIKit

protocol UserLikedMovie: AnyObject {
    
    func userChangedLike(likeState: Bool, cellIndex: IndexPath)
}

class MovieDetailViewController: BaseViewController {

    // MARK: - Variables
    private var viewModel: MovieDetailViewModelProtocol?
    private var movieId = 0
    private var userLiked = false
    private var initialLikeState = false
    private var finalLikeState = false
    private var likedMovieIds: [Int?] = []
    private weak var likedDelegate: UserLikedMovie?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var movieOverview: UILabel!
    @IBOutlet private weak var voteCountOuterView: UIView!
    @IBOutlet private weak var voteCount: UILabel!
    @IBOutlet private weak var starButton: UIBarButtonItem!
    @IBOutlet private weak var backButton: UIBarButtonItem!
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieDetailViewModel(delegate: self, currentId: self.movieId)
        setupUI()
        initialLikeState = userLiked
        showLoadingView()
        viewModel?.fetchMovieDetails(movieId: movieId)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        finalLikeState = userLiked
        if let indexPath = viewModel?.cellIndex {
            likedDelegate?.userChangedLike(likeState: didLikeChange(), cellIndex: indexPath)
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func starButtonPressed(_ sender: Any) {

        if let isFavoriteMovie = viewModel?.isFavorite {
            if isFavoriteMovie {
                viewModel?.removeFromFavouriteMovies()
            } else {
                viewModel?.addToFavouriteMovies()
            }
        }
    }
    
    func setMovieDetailParameters(movieId: Int, cellIndex: IndexPath, delegate: UserLikedMovie?) {
        self.movieId = movieId
        likedDelegate = delegate
        self.viewModel?.cellIndex = cellIndex
    }
    
    // MARK: - SetupUI

    private func setupUI() {
        voteCountOuterView.setRounded()
        movieImage.layer.cornerRadius = MovieAppGlobalConstants.cornerRadiusforCellItems
    }
        
    private func didLikeChange() -> Bool {
        if initialLikeState == finalLikeState {
            return false
        } else {
            return true
        }
    }
}

extension MovieDetailViewController: MovieDetailViewModelDelegate {
    
    func showMovieDetails(model: MovieDetailModel?) {
            if let imagePath = model?.posterPath {
                if let imageUrl = URL(string: NetworkConstants.bigImageURL + imagePath) {
                    self.movieImage.loadImage(url: imageUrl, placeholder: UIImage(named: MovieAppGlobalConstants.placeholderMovieIcon))
                }
            }
            DispatchQueue.main.async {
                self.movieTitle.text = model?.title
                self.movieOverview.text = model?.overview
                self.voteCount.text = MovieAppGlobalConstants.voteCountLabel + String(model?.voteCount ?? 0)
                self.hideLoadingView()
                self.voteCountOuterView.isHidden = false
            }
        }
    
    func showFail(error: Error?) {
        DispatchQueue.main.async {
            self.hideLoadingView()
            self.showError(error: error)
        }
    }
    
    func setFavouriteMovieStar(isFavourite: Bool) {
        DispatchQueue.main.async {
            if isFavourite {
                self.starButton.image = UIImage(systemName: MovieAppGlobalConstants.filledStarIcon)
            } else {
                self.starButton.image = UIImage(systemName: MovieAppGlobalConstants.starIcon)

            }
        }
    }
}
