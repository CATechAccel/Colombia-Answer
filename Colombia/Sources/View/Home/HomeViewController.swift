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
    private let disposeBag = DisposeBag()
    private let activityIndicator = UIActivityIndicatorView()
    private let refreshControl = UIRefreshControl()

    enum Const {
        static let numberOfItemInLine = 3
        static let cellHeight: CGFloat = 100 // TODO: fix
    }

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
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

//    private func fetchAPI() {
//        viewModel.fetch()
//            .subscribe(on: SerialDispatchQueueScheduler(qos: .background))
//            .observe(on: MainScheduler.instance)
//            .subscribe(
//                onNext: {[weak self] decodeData in
//                    guard let self = self else { return }
//
//                    let works = decodeData.works.map {[weak self] in
//                        return WorkForDisplay(
//                            id: $0.id,
//                            title: $0.title,
//                            image: $0.image,
//                            isFavorited: self?.worksIndexModel.isIncludingInFavorite(workId: $0.id) ?? false
//                        )
//                    }
//
//                    self.worksIndexModel.works.accept(works)
//                    self.collectionView?.reloadData()
//                    self.afterFetch()
//                },
//                onError: {[weak self] error in
//                    self?.showRetryAlert(with: error, retryHandler: {[weak self] in
//                        self?.activityIndicator.startAnimating()
//                        self?.fetchAPI()
//                    })
//                    self?.afterFetch()
//                }
//            )
//            .disposed(by: disposeBag)
//    }

    private func afterFetch() {
        activityIndicator.stopAnimating()
        collectionView.refreshControl?.endRefreshing()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO 詳細画面に移動 router作るのもアリ
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

        // Output
        let dataSource = HomeDataSource()
        viewModel.output.works
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
