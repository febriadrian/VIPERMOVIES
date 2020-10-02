//
//  DiscoverMoviesViewController.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class DiscoverMoviesViewController: MoviesCollectionViewController {
    var presenter: IDiscoverMoviesViewToPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupParameters()
        setupNavigationItem()
    }

    private func setupNavigationItem() {
        title = "Discover"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(navToGenres))
    }

    override func xViewWillAppear() {
        presenter?.mainViewController?.mainViewControllerDelegate = self

        if presenter?.isInitialLoading == true {
            loadingView.start {
                self.presenter?.getMovies()
            }
        }
    }

    override func startRefreshing() {
        presenter?.startRefreshing()
    }

    @objc private func navToGenres() {
        presenter?.navToGenres()
    }

    @objc private func didTapResetButton() {
        didSelectGenres(genreIds: nil, selectedIndex: nil)
        navigationItem.leftBarButtonItem = nil
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
        collectionView.registerCellType(DiscoverMoviesCollectionViewCell.self)
    }

    override func cellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(DiscoverMoviesCollectionViewCell.self, for: indexPath)
        cell.setupView(movie: movies[indexPath.item])
        return cell
    }

    override func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        let collWidth = collectionView.frame.size.width
        return CGSize(width: collWidth / 3, height: collWidth / 3)
    }

    override func referenceSizeForFooter() -> CGSize {
        if presenter?.isLoadingMore == true {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 30)
    }
}

extension DiscoverMoviesViewController: IDiscoverMoviesPresenterToView {
    func displayGetMovies(result: MoviesResult, movies: [MoviesModel.ViewModel]) {
        displayMovies(result: result, movies: movies)
    }
}

extension DiscoverMoviesViewController: GenresDelegate {
    func didSelectGenres(genreIds: [String]?, selectedIndex: [IndexPath]?) {
        if selectedIndex == nil {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(didTapResetButton))
        }
        
        loadingView.start {
            self.presenter?.didSelectGenres(genreIds: genreIds, selectedIndex: selectedIndex)
        }
    }
}

extension DiscoverMoviesViewController: MainViewControllerDelegate {
    func scrollToTop() {
        collectionViewScrollToTop()
    }
}
