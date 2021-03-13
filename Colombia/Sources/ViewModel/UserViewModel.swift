//
//  UserViewModel.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import RxSwift
import RxRelay

import RxCocoa
import RxSwift
import RxRelay

protocol UserViewModelInput {
    var input: UserViewModelInput { get }

    func viewDidLoad()
    func refresh()
}

protocol UserViewModelOutput {
    var output: UserViewModelOutput { get }

    var works: Driver<[Work]> { get }
}

struct UserViewModel: UserViewModelInput, UserViewModelOutput {

    private let disposeBag = DisposeBag()

    var input: UserViewModelInput { self }
    var output: UserViewModelOutput { self }

    init() {
        Observable.merge([
            viewDidLoadRelay.asObservable(),
            refreshRelay.asObservable(),
        ])
            .flatMap(fetch)
            .bind(to: worksRelay)
            .disposed(by: disposeBag)
    }

    private func fetch() -> Single<[Work]> {
        Single.just([])
    }

    // Input
    private let viewDidLoadRelay = PublishRelay<Void>()
    func viewDidLoad() {
        viewDidLoadRelay.accept(())
    }
    private let refreshRelay = PublishRelay<Void>()
    func refresh() {
        refreshRelay.accept(())
    }

    // Output
    private let worksRelay = BehaviorRelay<[Work]>(value: [])
    var works: Driver<[Work]> {
        worksRelay.asDriver()
    }
}
