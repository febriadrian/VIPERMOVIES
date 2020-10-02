//
//  GeneralRoute.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

enum GeneralRoute: IRouter {
    case homeMovies
    case movieDetail(parameter: [String: Any])
    case genres(parameter: [String: Any?])
}

extension GeneralRoute {
    var module: UIViewController? {
        switch self {
        case .homeMovies:
            return HomeMoviesConfiguration.setup()
        case .movieDetail(let parameter):
            return MovieDetailConfiguration.setup(parameters: parameter)
        case .genres(let parameter):
            return GenresConfiguration.setup(parameters: parameter as [String: Any])
        }
    }
}
