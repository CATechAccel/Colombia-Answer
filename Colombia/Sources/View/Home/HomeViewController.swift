//
//  HomeViewController.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel
    private let dataSource = HomeDataSource()
    private let disposeBag = DisposeBag()
    private let activityIndicator = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()

    enum Const {
        static let numberOfItemInLine = 3
        static let cellHeight: CGFloat = 140
    }

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.registerNib(FavoriteWorkCell.self)
            collectionView.refreshControl = refreshControl

            let layout = UICollectionViewFlowLayout()
            let cellWidth = collectionView.bounds.width / CGFloat(Const.numberOfItemInLine)
            layout.itemSize = CGSize(width: cellWidth, height: Const.cellHeight)
            collectionView.collectionViewLayout = layout

            let backgroundView = UIImageView()
            backgroundView.image = #imageLiteral(resourceName: "annict")
            backgroundView.contentMode = .scaleToFill
            collectionView.backgroundView = backgroundView
        }
    }

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            viewModel.input.viewDidLoad()
        }

        setComponent()
        bindViewModel()
        activityIndicator.startAnimating()
    }

    private func afterFetch() {
        activityIndicator.stopAnimating()
        collectionView.refreshControl?.endRefreshing()
    }
}

private extension HomeViewController {
    private func setComponent() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // WorkAround: メインスレッドの中にいれないと真ん中にならない
            self.activityIndicator.center = self.view.center
            self.activityIndicator.color = .white
            self.activityIndicator.style = .large
            self.view.addSubview(self.activityIndicator)
        }
    }

    private func bindViewModel() {
        // Input
        collectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .subscribe(onNext: viewModel.input.refresh)
            .disposed(by: disposeBag)

        collectionView.rx.modelSelected(Work.self)
            .asDriver()
            .drive(Binder(self) { me, work in
                me.viewModel.input.showWork(work: work)
            })
            .disposed(by: disposeBag)
        dataSource.favoriteWork
            .emit(onNext: viewModel.favoriteWork(work:))
            .disposed(by: disposeBag)
        dataSource.unfavoriteWork
            .emit(onNext: viewModel.unfavoriteWork(work:))
            .disposed(by: disposeBag)

        // Output
        viewModel.output.works
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
