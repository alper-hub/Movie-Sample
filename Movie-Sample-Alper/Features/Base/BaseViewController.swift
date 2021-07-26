//
//  BaseViewController.swift
//  Movie-Sample-Alper
//
//  Created by Alper Tufan on 7.07.2021.
//

import UIKit

protocol BaseViewControllerProtocol: AnyObject {
    func showError(error: Error?)
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
    
    private let loadingView:UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        view.alpha = 0.6
      return view
    }()
    
    var activityView = UIActivityIndicatorView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingView)
        showActivityIndicatory()
        clearLoadingView()
    }
    
    func showActivityIndicatory() {
        activityView.center = self.loadingView.center
        self.loadingView.addSubview(activityView)
        activityView.startAnimating()
    }
    func clearLoadingView()  {
        loadingView.isHidden = true
    }

    func showLoadingView() {
        loadingView.isHidden = false
    }
    
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
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
