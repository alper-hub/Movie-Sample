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
    func userChangedLike(likeState: Bool)
}

class MovieDetailViewController: BaseViewController {

    // MARK: - Variables
    
    var movieId = 0
    var userLiked = false
    var initialLikeState = false
    var finalLikeState = false
    var likedMovieIds: [Int?] = []
    weak var likedDelegate: UserLikedMovie?
    
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
        self.interactor = movieDetailInteractor
        self.presenter = movieDetailPresenter
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initialLikeState = userLiked
        presenter?.fetchMovieDetails(movieId: movieId)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        finalLikeState = userLiked
        likedDelegate?.userChangedLike(likeState: didLikeChange())
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func starButtonPressed(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if userLiked {
            userLiked = false
            starButton.image = UIImage(systemName: "star")
            if let likedMovies = defaults.array(forKey: "likedMovieIds")  {
                guard let likedIds: [Int] = likedMovies as? [Int] else {return}
                var temporaryArray = likedIds
                if let index = likedIds.firstIndex(of: (movieId)) {
                    temporaryArray.remove(at: index)
                    defaults.set(temporaryArray, forKey: "likedMovieIds")
                }
            }
        } else {
            userLiked = true
            starButton.image = UIImage(systemName: "star.fill")

            if var likedMovies = defaults.array(forKey: "likedMovieIds") {
                likedMovies.append(movieId as Any)
                defaults.set(likedMovies, forKey: "likedMovieIds")
            } else {
                likedMovieIds.append(movieId)
                defaults.setValue(likedMovieIds, forKey: "likedMovieIds")
            }
        }
    }
    
    // MARK: - SetupUI

    func setupUI() {
        voteCountOuterView.layer.cornerRadius = 10
        determineLiked()
    }
    
    func determineLiked() {
        let defaults = UserDefaults.standard
        if let likedMovies = defaults.array(forKey: "likedMovieIds") {
            let likedIds = likedMovies as! [Int]
            if likedIds.contains(movieId) {
                self.userLiked = true
                starButton.image = UIImage(systemName: "star.fill")
            }
        }
    }
        
    func didLikeChange() -> Bool {
        if initialLikeState == finalLikeState {
            return false
        } else {
            return true
        }
    }
}

extension MovieDetailViewController: MovieDetailViewControllerProtocol {
    
    func showMovieDetails(model: MovieDetailModel?) {
        DispatchQueue.main.async {
            
            if let imagePath = model?.poster_path {
                if let imageUrl = URL(string: NetworkConstants.imageURL + imagePath) {
                    self.movieImage.loadImage(url: imageUrl, placeholder: UIImage(named: "placeholderMovie"))
                }
            }
            self.movieTitle.text = model?.title
            self.movieOverview.text = model?.overview
            self.voteCount.text = String(model?.vote_count ?? 0)
        }
    }
    
    func showFail(error: Error?) {
        
    }
}
