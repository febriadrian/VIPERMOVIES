//
//  MoviesCollectionViewController.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 02/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MoviesCollectionViewController: UIViewController {
    lazy var contentView: UIView = {
        let cv = UIView()
        return cv
    }()

    lazy var layout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.keyboardDismissMode = .onDrag
        cv.showsVerticalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.refreshControl = refreshControl
        return cv
    }()

    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(startRefreshing), for: .valueChanged)
        return rc
    }()

    var loadingView: LoadingView!
    var movies: [MoviesModel.ViewModel] = []
    var scrollDelegate: MovieDetailScrollDelegate?
    var loadMoreView: LoadMoreReusableView?
    let loadMoreViewXib = "LoadMoreReusableView"
    var delegateCanScrollToTop = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        xViewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        xViewDidAppear()
        delegateCanScrollToTop = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegateCanScrollToTop = false
    }

    private func setupComponent() {
        loadingView = LoadingView()
        loadingView.setup(in: contentView)
        loadingView.reloadButton.touchUpInside(self, action: #selector(didTapReloadButton))

        let loadMoreViewNib = UINib(nibName: loadMoreViewXib, bundle: nil)
        collectionView.register(loadMoreViewNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: loadMoreViewXib)
        registerCellType()
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(contentView)
        contentView.addSubview(collectionView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
            contentView.topAnchor.constraint(equalTo: margins.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),

            collectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func collectionViewScrollToTop() {
        guard collectionView.numberOfItems(inSection: 0) > 2, delegateCanScrollToTop else { return }
        collectionView.scrollToItem(at: [0, 0], at: .bottom, animated: true)
    }

    @objc private func didTapReloadButton() {
        loadingView.start {
            self.getMovies()
        }
    }

    @objc func startRefreshing() {
        // override
    }

    func getMovies() {
        // override
    }

    func xViewWillAppear() {
        // override
    }

    func xViewDidAppear() {
        // override
    }

    func navToMovieDetail(id: Int) {
        // override
    }

    func didScrollToMaxontentOffset() {
        // override
    }

    func willDisplayCellForItem(indexPath: IndexPath) {
        // override
    }

    func registerCellType() {
        // override
    }

    func cellForItemAt(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        // override
        return UICollectionViewCell()
    }

    func sizeForItemAt(indexPath: IndexPath) -> CGSize {
        // override
        return CGSize.zero
    }

    func referenceSizeForFooter() -> CGSize {
        // override
        return CGSize.zero
    }
}

extension MoviesCollectionViewController {
    func displayMovies(result: MoviesResult, movies: [MoviesModel.ViewModel]) {
        self.movies = movies

        switch result {
        case .successInitialLoading:
            collectionView.reloadData()
            loadingView.stop()

        case .successRefreshing:
            collectionView.reloadData()
            refreshControl.endRefreshing()

        case .successLoadMore(let indexPaths):
            loadMoreView?.activityIndicator.isHidden = true
            loadMoreView?.activityIndicator.alpha = 0
            collectionView.performBatchUpdates({
                self.collectionView.insertItems(at: indexPaths)
            })

        case .failureInitialLoading(let message):
            loadingView.stop(isFailed: true, message: message)

        case .failureRefreshing(let message):
            Toast.share.show(message: message) {
                self.refreshControl.endRefreshing()
            }

        case .failureLoadMore(let message, let indexPath):
            Toast.share.show(message: message) {
                self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

extension MoviesCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForItemAt(collectionView, indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = movies[indexPath.item].id
        navToMovieDetail(id: id)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayCellForItem(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItemAt(indexPath: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return referenceSizeForFooter()
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: loadMoreViewXib, for: indexPath) as! LoadMoreReusableView
            loadMoreView = aFooterView
            loadMoreView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            loadMoreView?.activityIndicator.startAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            loadMoreView?.activityIndicator.stopAnimating()
        }
    }
}

extension MoviesCollectionViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxContentOffset = scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom
        let currentContentOffset = scrollView.contentOffset.y
        scrollDelegate?.didScroll(yOffset: currentContentOffset)

        guard currentContentOffset == maxContentOffset else { return }
        didScrollToMaxontentOffset()
    }
}
