//
//  Endpoint.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import Alamofire
import Foundation

enum Endpoint {
    case popularMovies(model: MoviesModel.Request)
    case playingMovies(model: MoviesModel.Request)
    case upcomingMovies(model: MoviesModel.Request)
    case topratedMovies(model: MoviesModel.Request)
    case discover(model: DiscoverMoviesModel.Request)
    case genres(model: GenresModel.Request)
    case movieDetail(model: MovieDetailModel.Request)
    case movieSimilar(model: SimilarMoviesModel.Request)
    case movieReviews(model: ReviewModel.Request)
}

extension Endpoint: IEndpoint {
    var path: String {
        switch self {
        case .popularMovies:
            return Constant.apiBaseUrl + "/movie/popular"
        case .playingMovies:
            return Constant.apiBaseUrl + "/movie/now_playing"
        case .upcomingMovies:
            return Constant.apiBaseUrl + "/movie/upcoming"
        case .topratedMovies:
            return Constant.apiBaseUrl + "/movie/top_rated"
        case .discover:
            return Constant.apiBaseUrl + "/discover/movie"
        case .genres:
            return Constant.apiBaseUrl + "/genre/movie/list"
        case .movieDetail(let model):
            return Constant.apiBaseUrl + "/movie/\(model.id)"
        case .movieSimilar(let model):
            return Constant.apiBaseUrl + "/movie/\(model.id)/similar"
        case .movieReviews(let model):
            return Constant.apiBaseUrl + "/movie/\(model.id)/reviews"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .popularMovies,
             .playingMovies,
             .upcomingMovies,
             .topratedMovies,
             .discover,
             .genres,
             .movieDetail,
             .movieSimilar,
             .movieReviews:
            return .get
        }
    }

    var parameter: Parameters? {
        switch self {
        case .popularMovies(let model):
            return model.parameters()
        case .playingMovies(let model):
            return model.parameters()
        case .upcomingMovies(let model):
            return model.parameters()
        case .topratedMovies(let model):
            return model.parameters()
        case .discover(let model):
            return model.parameters()
        case .genres(let model):
            return model.parameters()
        case .movieDetail(let model):
            return model.parameters()
        case .movieSimilar(let model):
            return model.parameters()
        case .movieReviews(let model):
            return model.parameters()
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .popularMovies,
             .playingMovies,
             .upcomingMovies,
             .topratedMovies,
             .discover,
             .genres,
             .movieDetail,
             .movieSimilar,
             .movieReviews:
            return URLEncoding.queryString
        }
    }

    var header: HTTPHeaders? {
        return [
            "Content-Type": "application/json",
        ]
    }
}
