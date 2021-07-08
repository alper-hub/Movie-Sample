//
//  BaseViewController.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import UIKit

protocol BaseViewControllerProtocol: class {
    func showError(error: Error?)
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        
    }
    
    func showError(error: Error?) {

    }
    

}
