//
//  HomeMoviesEntity.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import SwiftyJSON

enum MovieCategory {
    case popular
    case playing
    case upcoming
    case toprated
}

enum MoviesResult {
    case successInitialLoading
    case successRefreshing
    case successLoadMore([IndexPath])
    case failureInitialLoading(String)
    case failureRefreshing(String)
    case failureLoadMore(String, IndexPath)
}

struct MoviesModel {
    struct Request {
        var page: Int?

        func parameters() -> [String: Any]? {
            return [
                "api_key": Constant.apiKey,
                "page": page ?? 1,
                "language": "en-US"
            ]
        }
    }

    struct Response {
        var page: Int?
        var totalResults: Int?
        var totalPages: Int?
        var results: [Results]?

        init(data: JSON?) {
            self.page = data?["page"].int
            self.totalResults = data?["total_results"].int
            self.totalPages = data?["total_pages"].int

            if let items = data?["results"].array {
                self.results = items.map { Results(data: JSON($0.object)) }
            }
        }

        struct Results {
            var id: Int?
            var title: String?
            var posterPath: String?
            var overview: String?
            var releaseDate: String?
            var voteAverage: Double?

            init(data: JSON?) {
                self.id = data?["id"].int
                self.title = data?["title"].string
                self.posterPath = data?["poster_path"].string
                self.overview = data?["overview"].string
                self.releaseDate = data?["release_date"].string
                self.voteAverage = data?["vote_average"].double
            }
        }
    }

    struct ViewModel {
        var id: Int
        var title: String
        var posterUrl: String
        var voteAverage: String
        var overview: String
        var releaseDate: String
        var favorite: Bool
        var createdAt: Int
    }
}
