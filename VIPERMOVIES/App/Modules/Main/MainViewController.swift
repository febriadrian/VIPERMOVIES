//
//  MainViewController.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate {
    func scrollToTop()
}

class MainViewController: UITabBarController {
    var mainViewControllerDelegate: MainViewControllerDelegate?
    var home: HomeViewController!
    var discover: DiscoverMoviesViewController!
    var favorite: FavoriteMoviesViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let parameter = ["mainvc": self]

        home = HomeConfiguration.setup(parameters: parameter) as? HomeViewController
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tab_home"), tag: 0)

        discover = DiscoverMoviesConfiguration.setup(parameters: parameter) as? DiscoverMoviesViewController
        discover.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(named: "tab_discover"), tag: 1)

        favorite = FavoriteMoviesConfiguration.setup(parameters: parameter) as? FavoriteMoviesViewController
        favorite.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "tab_favorite"), tag: 2)

        viewControllers = [home, discover, favorite].map { UINavigationController(rootViewController: $0) }

        tabBar.tintColor = Colors.lightBlue
        delegate = self
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        mainViewControllerDelegate?.scrollToTop()
    }
}
