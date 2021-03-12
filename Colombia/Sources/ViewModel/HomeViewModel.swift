//
//  HomeViewModel.swift
//  Colombia
//
//  Created by 化田晃平 on R 3/02/25.
//

import RxSwift
import RxRelay

struct HomeViewModel {
    let works = BehaviorRelay<[Work]>(value: [])

    func fetch() -> Single<[Work]> {
        Single.just([])
    }
}
