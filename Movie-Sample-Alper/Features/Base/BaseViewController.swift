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
    
    // MARK: - Variables

    private let loadingView:UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .white
        view.alpha = 0.6
      return view
    }()
    
    private var activityView = UIActivityIndicatorView()
   
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loadingView)
        setupActivityIndicator()
        hideLoadingView()
    }
    
    // MARK: - SetupUI
    
    func setupActivityIndicator() {
        activityView.style = .large
        activityView.center = loadingView.center
        loadingView.addSubview(activityView)
    }
    
    func hideLoadingView()  {
        loadingView.isHidden = true
        activityView.stopAnimating()
    }

    func showLoadingView() {
        loadingView.isHidden = false
        activityView.startAnimating()
    }
    
    // MARK: - initialization

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
    
    // MARK: - Actions

    func showError(error: Error?) {
        let alert = UIAlertController(title: MovieAppGlobalConstants.errorMessageOops, message: error?.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: MovieAppGlobalConstants.errorMessageOkay, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
