//
//  GenresViewController.swift
//  VIPERMOVIES
//
//  Created by Febri Adrian on 01/10/20.
//  Copyright © 2020 Febri Adrian. All rights reserved.
//

import UIKit

class GenresViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!

    var presenter: IGenresViewToPresenter?
    var delegate: GenresDelegate?
    var genres: [GenresModel.ViewModel] = []
    private var loadingView: LoadingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.setupParameters()
        setupComponent()
    }

    private func setupComponent() {
        title = "Genres"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelButton))

        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellType(GenresTableViewCell.self)

        loadingView = LoadingView()
        loadingView.reloadButton.touchUpInside(self, action: #selector(didTapReloadButton))
        loadingView.setup(in: contentView) {
            self.loadingView.start {
                self.presenter?.getGenres()
            }
        }
    }

    @objc private func didTapReloadButton() {
        loadingView.start {
            self.presenter?.getGenres()
        }
    }

    private func setupRightBarButton() {
        if presenter?.selectedCount == 0 {
            navigationItem.rightBarButtonItem = nil
            doneButton.isHidden = true
        } else {
            doneButton.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(didTapResetButton))
        }
    }

    private func setupCurrentSelectedGenres() {
        guard let indexPaths = presenter?.selectedIndex else { return }
        presenter?.selectedIndex?.removeAll()
        for indexPath in indexPaths {
            _ = tableView.delegate?.tableView?(tableView, willSelectRowAt: indexPath)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        }
    }

    @objc private func didTapResetButton() {
        guard let indexPaths = presenter?.selectedIndex else { return }
        for indexPath in indexPaths {
            _ = tableView.delegate?.tableView?(tableView, willDeselectRowAt: indexPath)
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.delegate?.tableView?(tableView, didDeselectRowAt: indexPath)
        }

        delegate?.didSelectGenres(genreIds: nil, selectedIndex: nil)
        dismiss()
    }

    @objc private func didTapCancelButton() {
        dismiss()
    }

    @IBAction func didTapDoneButton(_ sender: UIButton) {
        delegate?.didSelectGenres(genreIds: presenter?.genresIds, selectedIndex: presenter?.selectedIndex)
        dismiss()
    }
}

extension GenresViewController: IGenresPresenterToView {
    func displayGetGenres(result: GeneralResult, genres: [GenresModel.ViewModel]) {
        self.genres = genres
        tableView.reloadData()

        switch result {
        case .success:
            loadingView.stop()
            DispatchQueue.main.async {
                self.setupCurrentSelectedGenres()
            }
        case .failure(let message):
            loadingView.stop(isFailed: true, message: message)
        }
    }
}

extension GenresViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GenresTableViewCell.self, for: indexPath)
        cell.setupView(genre: genres[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectGenreId(at: indexPath.row)
        presenter?.selectedIndex = self.tableView.indexPathsForSelectedRows
        setupRightBarButton()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        presenter?.didDeselectGenreId(at: indexPath.row)
        presenter?.selectedIndex = self.tableView.indexPathsForSelectedRows
        setupRightBarButton()
    }
}
