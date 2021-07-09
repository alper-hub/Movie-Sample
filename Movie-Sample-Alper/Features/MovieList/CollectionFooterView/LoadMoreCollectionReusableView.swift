//
//  LoadMoreCollectionReusableView.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 8.07.2021.
//

import UIKit

protocol LoadMoreDelegate: AnyObject {
    func loadMorePressed()
}

class LoadMoreCollectionReusableView: UICollectionReusableView {
    
    weak var delegate: LoadMoreDelegate?

    @IBOutlet weak var loadMoreButtonOutlet: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        loadMoreButtonOutlet.layer.cornerRadius = 10
    }
    
    @IBAction func loadMoreButtonPressed(_ sender: Any) {
        delegate?.loadMorePressed()
    }
}
