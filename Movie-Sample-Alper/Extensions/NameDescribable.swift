//
//  NameDescribable.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 27.07.2021.
//

import Foundation

protocol NameDescribable {
    
    var typeName: String { get }
    static var typeName: String { get }
}

extension NameDescribable {
    
    var typeName: String {
        return String(describing: type(of: self))
    }

    static var typeName: String {
        return String(describing: self)
    }
}

extension NSObject: NameDescribable {}
extension Array: NameDescribable {}
