//
//  MovieListCollectionViewCell.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {

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
    @IBOutlet weak var starOuterView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        outerView.layer.cornerRadius = 10
        movieImage.layer.cornerRadius = 10
        starOuterView.layer.cornerRadius = 0.5 * starOuterView.bounds.size.width

    }
    
    func fillFields() {
        movieTitle.text = movieListCollectionCellData?.title
        if let imagePath = movieListCollectionCellData?.poster_path {
            getImage(imagePath: NetworkConstants.imageURL + imagePath)
        }
    }
    
    func getImage(imagePath: String) {
        let url = URL(string: imagePath)!
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.movieImage.image = UIImage(data: data)
                }
            }
        }
    }
}

