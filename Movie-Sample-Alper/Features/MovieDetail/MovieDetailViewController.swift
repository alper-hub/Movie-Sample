//
//  MovieDetailViewController.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import UIKit

protocol UserLikedMovie: AnyObject {
    func userChangedLike(likeState: Bool)
}

class MovieDetailViewController: UIViewController {

    // MARK: - Outlets
    
    var movieData: MovieListModel?
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
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initialLikeState = userLiked
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
                if let index = likedIds.firstIndex(of: (movieData?.id ?? 0)) {
                    temporaryArray.remove(at: index)
                    defaults.set(temporaryArray, forKey: "likedMovieIds")
                }
            }
        } else {
            userLiked = true
            starButton.image = UIImage(systemName: "star.fill")

            if var likedMovies = defaults.array(forKey: "likedMovieIds") {
                likedMovies.append(movieData?.id as Any)
                defaults.set(likedMovies, forKey: "likedMovieIds")
            } else {
                likedMovieIds.append(movieData?.id)
                defaults.setValue(likedMovieIds, forKey: "likedMovieIds")
            }
        }
    }
    
    // MARK: - SetupUI

    func setupUI() {
        if let imagePath = movieData?.poster_path {
            if let imageUrl = URL(string: NetworkConstants.imageURL + imagePath) {
                movieImage.loadImage(url: imageUrl, placeholder: UIImage(named: "placeholderMovie"))
            }
        }
        movieTitle.text = movieData?.title
        movieOverview.text = movieData?.overview
        voteCount.text = String(movieData?.vote_count ?? 0)
        voteCountOuterView.layer.cornerRadius = 10
        determineLiked()
    }
    
    func determineLiked() {
        let defaults = UserDefaults.standard
        if let likedMovies = defaults.array(forKey: "likedMovieIds") {
            let likedIds = likedMovies as! [Int]
            if likedIds.contains(movieData?.id ?? 0) {
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

