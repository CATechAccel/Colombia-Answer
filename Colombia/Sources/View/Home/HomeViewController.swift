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

    enum Const {
        static let numberOfRows = 3
    }

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerNib(WorksIndexCollectionViewCell.self)
            let layout = UICollectionViewFlowLayout()
//            layout.minimumInteritemSpacing = 30　TODO: 修正

//            let cellSize = (collectionView.bounds.width) / CGFloat(Const.numberOfRows)
//            layout.itemSize = CGSize(width: cellSize, height: cellSize + 15) TODO: 修正
            collectionView.collectionViewLayout = layout

            let bgImage = UIImageView()
            bgImage.image = UIImage(named: "annict")
            bgImage.contentMode = .scaleToFill
            collectionView.backgroundView = bgImage
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        collectionView.refreshControl = refreshControl

        setComponent()

        collectionView.refreshControl?.rx.controlEvent(.valueChanged)
            .subscribe(
                onNext: {[weak self] in
                    self?.fetchAPI()
                })
            .disposed(by: disposeBag)

        activityIndicator.startAnimating()

        fetchAPI()
    }

    private func setComponent() {
        DispatchQueue.main.async {
            // メインスレッドの中にいれないと真ん中にならない
            self.activityIndicator.center = self.view.center
            self.activityIndicator.color = .white
            self.activityIndicator.style = .large
            self.view.addSubview(self.activityIndicator)
        }
    }

    private func fetchAPI() {
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
    }

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

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.works.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(WorksIndexCollectionViewCell.self, for: indexPath)

        let work = viewModel.works.value[indexPath.row]
        cell.configure(work: work)
        cell.isFavorited = work.isFavorited

        cell.favoriteButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self = self else { return }
                var work = self.viewModel.works.value[indexPath.row]
                work.isFavorited.toggle()
                cell.isFavorited = work.isFavorited
//                    self.viewModel.favoriteValueChanged.accept((work, .index)) // TODO: これいい感じにできるはずなので修正
            })
            .disposed(by: cell.disposeBag)

        return cell
    }
}
