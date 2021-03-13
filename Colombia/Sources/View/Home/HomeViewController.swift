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
    }

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.registerNib(FavoriteWorkCell.self)
            collectionView.refreshControl = refreshControl

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.18)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: Const.numberOfItemInLine
            )
            let section = NSCollectionLayoutSection(group: group)
            let layout = UICollectionViewCompositionalLayout(section: section)
            collectionView.collectionViewLayout = layout

            let backgroundView = UIImageView()
            backgroundView.image = #imageLiteral(resourceName: "annict")
            backgroundView.contentMode = .scaleAspectFill
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
            .drive(with: self) { me, work in
                me.viewModel.input.showWork(work: work)
            }
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

        viewModel.output.loadingStatus
            .drive(with: self) { (me, loadingStatus) in
                switch loadingStatus {
                case .initial:
                    me.activityIndicator.startAnimating()
                case .loading:
                    break
                case .loaded, .loadFailed:
                    me.activityIndicator.stopAnimating()
                    me.collectionView.refreshControl?.endRefreshing()
                }
            }.disposed(by: disposeBag)
    }
}
