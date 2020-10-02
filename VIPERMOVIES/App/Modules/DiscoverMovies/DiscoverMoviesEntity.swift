//
//  DiscoverMoviesEntity.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import SwiftyJSON

struct DiscoverMoviesModel {
    struct Request {
        var genreIds: String?
        var page: Int?

        func parameters() -> [String: Any]? {
            return [
                "api_key": Constant.apiKey,
                "page": page ?? 1,
                "with_genres": genreIds ?? "10749",
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
        private var movie: Response.Results

        init(movie: Response.Results) {
            self.movie = movie
        }

        var id: Int {
            return movie.id ?? 0
        }

        var posterUrl: String {
            let path = movie.posterPath ?? ""
            return ImageUrl.poster + path
        }

        var voteAverage: String {
            if let rating = movie.voteAverage, rating != 0 {
                return "\(rating)"
            }
            return "n/a"
        }
    }
}
