//
//  FavoriteMoviesViewController.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!

    var presenter: IFavoriteMoviesViewToPresenter?
    private var refreshControl: UIRefreshControl!
    private var loadingView: LoadingView!
    private var movies: [MoviesModel.ViewModel] = []
    private var delegateCanScrollToTop = false
    private let noFavoriteMovies = "You have no Favorite Movies.."

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupParameters()
        setupComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.mainViewController?.mainViewControllerDelegate = self
        presenter?.getMovies()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegateCanScrollToTop = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegateCanScrollToTop = false
    }

    private func setupComponent() {
        title = "Favorites"
        presenter?.mainViewController?.mainViewControllerDelegate = self

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerCellType(HomeMoviesCollectionViewCell.self)
        collectionView.refreshControl = refreshControl

        loadingView = LoadingView()
        loadingView.delegate = self
        loadingView.setup(in: contentView)
        loadingView.reloadButton.setTitle("Discover Movies", for: .normal)
    }

    private func checkCurrentFavoriteMovies() {
        if movies.count == 0 {
            loadingView.start {
                self.presenter?.getMovies()
            }
        }
    }
}

extension FavoriteMoviesViewController: IFavoriteMoviesPresenterToView {
    func displayMovies(movies: [MoviesModel.ViewModel]) {
        self.movies = movies
        collectionView.reloadData()

        if movies.count == 0 {
            loadingView.stop(isFailed: true, message: noFavoriteMovies)
        } else {
            loadingView.stop()
        }
    }
}

extension FavoriteMoviesViewController: LoadingViewDelegate {
    func didTapReloadButton() {
        presenter?.mainViewController?.selectedIndex = 1
    }
}

extension FavoriteMoviesViewController: MainViewControllerDelegate {
    func scrollToTop() {
        guard collectionView.numberOfItems(inSection: 0) > 2, delegateCanScrollToTop else { return }
        collectionView.scrollToItem(at: [0, 0], at: .bottom, animated: true)
    }
}

extension FavoriteMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HomeMoviesCollectionViewCell.self, for: indexPath)
        cell.setupView(movie: movies[indexPath.item])
        cell.handleFavorite = { [weak self] favorite in
            guard let movie = self?.movies[indexPath.item], favorite else { return }
            Helper.updateFavorite(movie: movie, favorite: favorite) {
                collectionView.performBatchUpdates({
                    self?.movies.remove(at: indexPath.item)
                    collectionView.deleteItems(at: [indexPath])
                })

                self?.checkCurrentFavoriteMovies()
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
