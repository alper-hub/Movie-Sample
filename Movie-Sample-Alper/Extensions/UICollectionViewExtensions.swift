//
//  UICollectionViewExtensions.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 28.07.2021.
//

import UIKit

extension UICollectionView {
    
    func dequeue<T: UICollectionViewCell>(withIdentifier identifier: String = String(describing: T.self), for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(identifier) from collectionView \(self)")
        }
        return cell
    }
    
    func dequeueSupplementaryView<T: UICollectionReusableView>(withIdentifier identifier: String = String(describing: T.self), for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier \(identifier) from collectionView \(self)")
        }
        return cell
    }
}
