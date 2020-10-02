//
//  MovieDetailReviewViewController.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailReviewViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!

    var presenter: IMovieDetailReviewViewToPresenter?
    var main: MovieDetailViewController?
    var scrollDelegate: MovieDetailScrollDelegate?
    var loadingView: LoadingView!
    var reviews: [ReviewModel.ViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupParameters()
        setupComponent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        main?.shouldSelectControllerByScroll = true
    }

    private func setupComponent() {
        main = presenter?.parameters?["main"] as? MovieDetailViewController

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellType(ReviewTableViewCell.self)

        loadingView = LoadingView()
        loadingView.delegate = self
        loadingView.setup(in: contentView) {
            self.loadingView.start {
                self.presenter?.getReviews()
            }
        }
    }
}

extension MovieDetailReviewViewController: IMovieDetailReviewPresenterToView {
    func displayGetMovies(result: GeneralResult, reviews: [ReviewModel.ViewModel]) {
        self.reviews = reviews

        switch result {
        case .success:
            loadingView.stop()
            tableView.reloadData()

        case .failure(let message):
            loadingView.stop(isFailed: true, message: message)
        }
    }
}

extension MovieDetailReviewViewController: LoadingViewDelegate {
    func didTapReloadButton() {
        loadingView.start {
            self.presenter?.getReviews()
        }
    }
}

extension MovieDetailReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ReviewTableViewCell.self, for: indexPath)
        cell.setupView(review: reviews[indexPath.row])
        cell.handleUpdateCell = { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        }
        return cell
    }
}

extension MovieDetailReviewViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.didScroll(yOffset: scrollView.contentOffset.y)
    }
}
