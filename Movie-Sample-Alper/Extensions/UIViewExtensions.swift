//
//  UIViewExtensions.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 27.07.2021.
//

import Foundation
import UIKit

extension UIView {
    
    func setRounded() {
        let radius = self.frame.height / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
