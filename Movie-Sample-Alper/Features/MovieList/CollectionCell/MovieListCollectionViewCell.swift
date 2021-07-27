//
//  MovieListCollectionViewCell.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {

    // MARK: - Constants

    private struct Constants {
        static let screenWidth = UIScreen.main.bounds.width
        static let cellWidth = screenWidth * 0.425
    }
    
    // MARK: - Variables
    var movieListCollectionCellData: MovieListModel? {
        didSet {
            fillFields()
        }
    }    
    // MARK: - Outlets

    @IBOutlet private weak var outerView: UIView!
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var starOuterView: UIView!
    @IBOutlet weak var cellWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        outerView.layer.cornerRadius = 10
        movieImage.layer.cornerRadius = 10
        starOuterView.layer.cornerRadius = 0.5 * starOuterView.bounds.size.width
        cellWidth.constant = Constants.cellWidth
    }
    
    func fillFields() {
        movieTitle.text = movieListCollectionCellData?.title
        if let isFavourite = movieListCollectionCellData?.isFavoriteMovie {
            if isFavourite {
                starOuterView.isHidden = false
            } else {
                starOuterView.isHidden = true
            }
        }
        if let imagePath = movieListCollectionCellData?.poster_path {
            if let imageUrl = URL(string: NetworkConstants.imageURL + imagePath) {
                movieImage.loadImage(url: imageUrl, placeholder: UIImage(named: "placeholderMovie"))
            }
        }
    }
    
}

