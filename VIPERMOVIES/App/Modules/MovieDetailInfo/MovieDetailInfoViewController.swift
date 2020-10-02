//
//  MovieDetailInfoViewController.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class MovieDetailInfoViewController: UIViewController {
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var companiesLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var countriesLabel: UILabel!
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var castCollectionView: UICollectionView!
    @IBOutlet weak var crewCollectionView: UICollectionView!
    @IBOutlet weak var castView: UIView!
    @IBOutlet weak var crewView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var trailerView: UIView!
    @IBOutlet weak var trailerCollectionView: UICollectionView!

    var presenter: IMovieDetailInfoViewToPresenter?
    var main: MovieDetailViewController?
    var scrollDelegate: MovieDetailScrollDelegate?
    var lastYOffset: CGFloat = 0

    var detail: MovieDetailModel.MVDetailModel? {
        didSet {
            guard let detail = detail else { return }
            genresLabel.text = detail.genres
            overviewLabel.text = detail.overview
            companiesLabel.text = detail.prodCompanies
            countriesLabel.text = detail.prodCountries
            homepageLabel.text = detail.homepage
            revenueLabel.text = detail.revenue
            budgetLabel.text = detail.budget
            originalTitleLabel.text = detail.originalTitle
            taglineLabel.text = detail.tagline
        }
    }

    var cast: [MovieDetailModel.PersonModel]? {
        didSet {
            guard cast != nil else { return }
            castCollectionView.reloadData()
        }
    }

    var crew: [MovieDetailModel.PersonModel]? {
        didSet {
            guard crew != nil else { return }
            crewCollectionView.reloadData()
        }
    }

    var trailers: [MovieDetailModel.YoutubeTrailerModel]? {
        didSet {
            guard trailers != nil else { return }
            trailerCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponent()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        main?.shouldSelectControllerByScroll = true
    }

    private func setupComponent() {
        main = presenter?.parameters?["main"] as? MovieDetailViewController

        scrollView.delegate = self
        trailerCollectionView.delegate = self
        castCollectionView.delegate = self
        crewCollectionView.delegate = self
        trailerCollectionView.dataSource = self
        castCollectionView.dataSource = self
        crewCollectionView.dataSource = self
        trailerCollectionView.registerCellType(TrailerCollectionViewCell.self)
        castCollectionView.registerCellType(PeopleCollectionViewCell.self)
        crewCollectionView.registerCellType(PeopleCollectionViewCell.self)

        taglineLabel.font = UIFont.systemFont(ofSize: 16).italic()
    }
}

extension MovieDetailInfoViewController: IMovieDetailInfoPresenterToView {
    //
}

extension MovieDetailInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case castCollectionView:
            return cast?.count ?? 0
        case crewCollectionView:
            return crew?.count ?? 0
        default:
            return trailers?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case castCollectionView:
            let cell = collectionView.dequeueReusableCell(PeopleCollectionViewCell.self, for: indexPath)
            guard let cast = cast?[indexPath.item] else { return cell }
            cell.setupPersonView(person: cast)
            return cell

        case crewCollectionView:
            let cell = collectionView.dequeueReusableCell(PeopleCollectionViewCell.self, for: indexPath)
            guard let crew = crew?[indexPath.item] else { return cell }
            cell.setupPersonView(person: crew)
            return cell

        default:
            let cell = collectionView.dequeueReusableCell(TrailerCollectionViewCell.self, for: indexPath)
            guard let trailer = trailers?[indexPath.item] else { return cell }
            cell.setupView(trailer: trailer)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == trailerCollectionView else { return }
        guard let url = trailers?[indexPath.item].videoUrl else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == trailerCollectionView {
            return CGSize(width: 177, height: 118)
        }
        return CGSize(width: 84, height: 118)
    }
}

extension MovieDetailInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let yOffset = scrollView.contentOffset.y

        if xOffset == 0 || xOffset != 0, yOffset != 0 {
            lastYOffset = yOffset
        }

        scrollDelegate?.didScroll(yOffset: lastYOffset)
    }
}
