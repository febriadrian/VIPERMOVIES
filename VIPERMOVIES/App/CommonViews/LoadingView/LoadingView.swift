//
//  LoadingView.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

protocol LoadingViewDelegate {
    func didTapReloadButton()
}

class LoadingView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var reloadButton: UIButton!
    
    private let xibName = "LoadingView"
    private var view: UIView!
    var delegate: LoadingViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(xibName, owner: self, options: nil)
        contentView.fixInView(self)
        messageLabel.text = Messages.loading
    }
    
    @IBAction func startReload(_ sender: UIButton) {
        delegate?.didTapReloadButton()
    }
    
    func setup(in view: UIView, completion: (() -> Void)? = nil) {
        self.view = view
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        completion?()
    }
    
    func start(completion: (() -> Void)? = nil) {
        messageLabel.text = Messages.loading
        activityIndicator.startAnimating()
        reloadButton.alpha = 0
        reloadButton.isHidden = true
        view.bringSubviewToFront(contentView)
        animateViews(animations: {
            self.contentView.alpha = 1
            self.activityIndicator.alpha = 1
            self.messageLabel.alpha = 1
            self.activityIndicator.isHidden = false
            self.messageLabel.isHidden = false
        }) {
            completion?()
        }
    }
    
    func stop(isFailed: Bool? = nil, message: String? = nil, completion: (() -> Void)? = nil) {
        if let message = message {
            messageLabel.text = message
        }
        
        if isFailed == true {
            reloadButton.isHidden = false
            reloadButton.alpha = 1
            view.bringSubviewToFront(contentView)
            animateViews(animations: {
                self.activityIndicator.isHidden = true
                self.messageLabel.isHidden = false
                self.activityIndicator.alpha = 0
                self.messageLabel.alpha = 1
            }) {
                completion?()
            }
        } else {
            animateViews(animations: {
                self.contentView.alpha = 0
                self.view.sendSubviewToBack(self.contentView)
            }) {
                completion?()
            }
        }
        
        activityIndicator.stopAnimating()
    }
    
    private func animateViews(animations: @escaping () -> Void, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                animations()
            }) { _ in
                completion?()
            }
        }
    }
}
