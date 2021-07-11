//
//  CollectionViewCellExtensions.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 11.07.2021.
//

import Foundation
import UIKit


extension UICollectionViewCell {

    static func register(to collectionView: UICollectionView?) {
        let className = String(describing: Self.self)
        let nib = UINib(nibName: className, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: className)
    }
}
