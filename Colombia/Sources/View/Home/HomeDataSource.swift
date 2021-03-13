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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(WorksIndexCollectionViewCell.self, for: indexPath)

        let work = items[indexPath.item]
        cell.configure(work: work)

        cell.favoriteButton.rx.tap
            .subscribe(onNext: {
                var work = work
                work.isFavorited.toggle()
                cell.isFavorited = work.isFavorited
//                    self.viewModel.favoriteValueChanged.accept((work, .index)) // TODO: これいい感じにできるはずなので修正
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
