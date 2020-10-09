//
//  MovieDetailSimilarViewController.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailSimilarViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var presenter: IMovieDetailSimilarViewToPresenter?
    var main: MovieDetailViewController?
    var scrollDelegate: MovieDetailScrollDelegate?
    var loadingView: LoadingView!
    var movies: [MoviesModel.ViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupParameters()
        setupComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if presenter?.isInitialLoading == false {
            presenter?.updateFavorite()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        main?.shouldSelectControllerByScroll = true
    }

    private func setupComponent() {
        main = presenter?.parameters?["main"] as? MovieDetailViewController

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellType(HomeMoviesCollectionViewCell.self)

        loadingView = LoadingView()
        loadingView.reloadButton.touchUpInside(self, action: #selector(didTapReloadButton))
        loadingView.setup(in: contentView) {
            self.loadingView.start {
                self.presenter?.getSimilarMovies()
            }
        }
    }

    @objc private func didTapReloadButton() {
        loadingView.start {
            self.presenter?.getSimilarMovies()
        }
    }
}

extension MovieDetailSimilarViewController: IMovieDetailSimilarPresenterToView {
    func displayGetMovies(result: GeneralResult, movies: [MoviesModel.ViewModel]) {
        self.movies = movies

        switch result {
        case .success:
            loadingView.stop()
            collectionView.reloadData()

        case .failure(let message):
            loadingView.stop(isFailed: true, message: message)
        }
    }

    func displayUpdateFavorite(movies: [MoviesModel.ViewModel]) {
        self.movies = movies
        collectionView.reloadData()
    }
}

extension MovieDetailSimilarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HomeMoviesCollectionViewCell.self, for: indexPath)
        cell.setupView(movie: movies[indexPath.item])
        cell.handleFavorite = { [weak self] favorite in
            guard let movie = self?.movies[indexPath.item] else { return }
            Helper.updateFavorite(movie: movie, favorite: favorite) {
                collectionView.performBatchUpdates({
                    self?.movies[indexPath.item].favorite = !favorite
                    guard let movie = self?.movies[indexPath.item] else { return }
                    cell.setupView(movie: movie)
                })
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = movies[indexPath.item].id
        presenter?.navToMovieDetail(id: id)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }
}

extension MovieDetailSimilarViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollDelegate?.didScroll(yOffset: scrollView.contentOffset.y)
    }
}
