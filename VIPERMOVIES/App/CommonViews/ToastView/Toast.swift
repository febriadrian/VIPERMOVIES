//
//  Toast.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class Toast {
    static let share = Toast()
    private var view: ToastView!
    
    init() {
        view = ToastView()
    }
    
    func show(message: String? = nil, completion: (() -> Void)? = nil) {
        guard let topMostView = UIApplication.shared.topMostViewController()?.view else { return }
        topMostView.endEditing(true)
        topMostView.addSubview(view)
        topMostView.bringSubviewToFront(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.messageLabel.text = message
        
        let margins = topMostView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: topMostView.leftAnchor),
            view.rightAnchor.constraint(equalTo: topMostView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -12)
        ])
        
        animateView(animations: {
            self.view.subView?.alpha = 1
        }) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.animateView(animations: {
                    self.view.subView?.alpha = 0
                }) {
                    self.view.removeFromSuperview()
                    completion?()
                }
            }
        }
    }
    
    private func animateView(animations: @escaping () -> Void, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: animations) { _ in
            completion()
        }
    }
}
