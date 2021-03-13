//
//  HomeDataSource.swift
//  Colombia
//
//  Created by 伊藤凌也 on 2021/03/13.
//

import UIKit
import RxCocoa
import RxSwift

final class HomeDataSource: NSObject, UICollectionViewDataSource {
    typealias Element = [Work]

    private var items: Element = []

    private let favoriteWorkRelay = PublishRelay<Work>()
    var favoriteWork: Signal<Work> {
        favoriteWorkRelay.asSignal()
    }
    private let unfavoriteWorkRelay = PublishRelay<Work>()
    var unfavoriteWork: Signal<Work> {
        unfavoriteWorkRelay.asSignal()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(FavoriteWorkCell.self, for: indexPath)

        let work = items[indexPath.item]
        cell.configure(work: work)

        cell.favoriteButton.rx.tap
            .bind(to: Binder(self) { me, _ in
                cell.isFavorited.toggle()
                if cell.isFavorited {
                    me.favoriteWorkRelay.accept(work)
                } else {
                    me.unfavoriteWorkRelay.accept(work)
                }
            })
            .disposed(by: cell.disposeBag)

        return cell
    }
}

extension HomeDataSource: RxCollectionViewDataSourceType {
    func collectionView(_ collectionView: UICollectionView, observedEvent: Event<[Work]>) {
        Binder(self) { dataSource, works in
            dataSource.items = works
            collectionView.reloadData()
        }.on(observedEvent)
    }
}
