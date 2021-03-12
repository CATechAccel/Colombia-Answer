//
//  UserViewController.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import UIKit
import RxSwift
import RxCocoa

final class UserViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.registerNib(WorksIndexCollectionViewCell.self)

            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 5, right: 30)
            layout.minimumInteritemSpacing = 5

            let showingRowNum = 3
            let cellSize = (collectionView.bounds.width - 130) / CGFloat(showingRowNum)
            layout.itemSize = CGSize(width: cellSize, height: cellSize + 15)
            collectionView.collectionViewLayout = layout

            let refreshControl = UIRefreshControl()
            refreshControl.tintColor = .white

            let bgImage = UIImageView()
            bgImage.image = UIImage(named: "annict")
            bgImage.contentMode = .scaleToFill
            collectionView.backgroundView = bgImage
        }
    }

    private let disposeBag = DisposeBag()
    private var viewModel: UserViewModel

    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        //お気に入り作品のデータ更新時にお気に入り画面のCollectionViewをreload
//        viewModel.favoritedWorks.subscribe(
//            onNext: {[weak self] _ in
//                guard let self = self else { return }
//                DispatchQueue.main.async {
//                    self.collectionView?.reloadData()
//                }
//            })
//            .disposed(by: disposeBag)
    }
}

extension UserViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // **TODO** 詳細画面に移動
    }
}

extension UserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.works.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(WorksIndexCollectionViewCell.self, for: indexPath)
        let work = viewModel.works.value[indexPath.row]

        cell.configure(work: work)
        cell.isFavorited = work.isFavorited

        cell.favoriteButton.rx.tap
            .subscribe(
                onNext: {[weak self] in
                    guard let self = self else { return }

                    var work = self.viewModel.works.value[indexPath.row]
                    work.isFavorited.toggle()
                    cell.isFavorited = work.isFavorited
//                    self.viewModel.favoriteValueChanged.accept((work, .favorite))
                })
            .disposed(by: cell.disposeBag)

        return cell
    }
}
