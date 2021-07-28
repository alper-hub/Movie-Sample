//
//  MovieDetailViewController.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import UIKit

protocol MovieDetailViewControllerDelegate: AnyObject {
    
    func userChangedLike(likeStateChanged: Bool, cellIndex: IndexPath)
}

class MovieDetailViewController: BaseViewController {

    // MARK: - Variables
    var viewModel: MovieDetailViewModelProtocol?
    weak var likedDelegate: MovieDetailViewControllerDelegate?
    
    // MARK: - Outlets
    
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var movieOverviewLabel: UILabel!
    @IBOutlet private weak var voteCountOuterView: UIView!
    @IBOutlet private weak var voteCountLabel: UILabel!
    @IBOutlet private weak var starButton: UIBarButtonItem!
    @IBOutlet private weak var backButton: UIBarButtonItem!
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showLoadingView()
        viewModel?.fetchMovieDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let currentFavoriteState = viewModel?.isFavorite {
            viewModel?.finalLikeState = currentFavoriteState
            if let indexPath = viewModel?.cellIndex {
                likedDelegate?.userChangedLike(likeStateChanged: didLikeChange(), cellIndex: indexPath)
            }
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
    
    // MARK: - SetupUI

    private func setupUI() {
        changeRatingStar(isFavorite: viewModel?.isFavorite ?? false)
        voteCountOuterView.setRounded()
        movieImage.layer.cornerRadius = MovieAppGlobalConstants.cornerRadiusforCellItems
    }
        
    private func didLikeChange() -> Bool {
        return viewModel?.initialLikeState != viewModel?.finalLikeState
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
                self.movieTitleLabel.text = model?.title
                self.movieOverviewLabel.text = model?.overview
                self.voteCountLabel.text = MovieAppGlobalConstants.voteCountLabel + String(model?.voteCount ?? 0)
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
    
    func changeRatingStar(isFavorite: Bool) {
        self.starButton.image = UIImage(systemName: isFavorite ? MovieAppGlobalConstants.filledStarIcon :  MovieAppGlobalConstants.starIcon)
    }
}
