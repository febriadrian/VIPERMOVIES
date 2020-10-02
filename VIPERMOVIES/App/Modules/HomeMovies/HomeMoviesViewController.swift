//
//  HomeMoviesViewController.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class HomeMoviesViewController: MoviesCollectionViewController {
    var presenter: IHomeMoviesViewToPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupParameters()
    }

    override func xViewWillAppear() {
        presenter?.homeViewController?.delegate = self

        if presenter?.isInitialLoading == true {
            loadingView.start {
                self.presenter?.getMovies()
            }
        } else {
            presenter?.updateFavorite()
        }
    }

    override func xViewDidAppear() {
        presenter?.homeViewController?.shouldSelectControllerByScroll = true
    }

    override func startRefreshing() {
        presenter?.startRefreshing()
    }

    override func getMovies() {
        presenter?.getMovies()
    }

    override func navToMovieDetail(id: Int) {
        presenter?.navToMovieDetail(id: id)
    }

    override func didScrollToMaxontentOffset() {
        guard let presenter = presenter else { return }
        if movies.count > 0, movies.count < presenter.totalResults, !presenter.isLoadingMore {
            loadMoreView?.activityIndicator.alpha = 1
            loadMoreView?.activityIndicator.isHidden = false
            presenter.startLoadMore()
        }
    }

    override func willDisplayCellForItem(indexPath: IndexPath) {
        guard let presenter = presenter else { return }
        guard movies.count > 0, movies.count < presenter.totalResults, indexPath.item == movies.count - 1, !presenter.isLoadingMore else { return
        }

        loadMoreView?.activityIndicator.alpha = 1
        loadMoreView?.activityIndicator.isHidden = false
        presenter.startLoadMore()
    }

    override func registerCellType() {
        collectionView.registerCellType(HomeMoviesCollectionViewCell.self)
    }

    override func cellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
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

    override func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 180)
    }

    override func referenceSizeForFooter() -> CGSize {
        if presenter?.isLoadingMore == true {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 30)
    }
}

extension HomeMoviesViewController: IHomeMoviesPresenterToView {
    func displayGetMovies(result: MoviesResult, movies: [MoviesModel.ViewModel]) {
        displayMovies(result: result, movies: movies)
    }

    func displayUpdateFavorite(movies: [MoviesModel.ViewModel]) {
        self.movies = movies
        collectionView.reloadData()
    }
}

extension HomeMoviesViewController: HomeViewControllerDelegate {
    func scrollToTop() {
        collectionViewScrollToTop()
    }
}
