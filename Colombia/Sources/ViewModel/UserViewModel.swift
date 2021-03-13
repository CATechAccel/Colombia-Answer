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

    func viewWillAppear()
    func viewDidLoad()
    func refresh()
    func showWork(work: Work)
    func favoriteWork(work: Work)
    func unfavoriteWork(work: Work)
}

protocol UserViewModelOutput {
    var output: UserViewModelOutput { get }

    var works: Driver<[Work]> { get }
}

struct UserViewModel: UserViewModelInput, UserViewModelOutput {
    struct Dependency {
        var router: MainRouter
        var realmRepository: RealmRepository
    }

    private var dependency: Dependency
    private let disposeBag = DisposeBag()

    var input: UserViewModelInput { self }
    var output: UserViewModelOutput { self }

    init(dependency: Dependency) {
        self.dependency = dependency
        Observable.merge([
            viewWillAppearRelay.asObservable(),
            viewDidLoadRelay.asObservable(),
            refreshRelay.asObservable(),
        ])
            .map(dependency.realmRepository.fetchFavoriteWorks)
            .bind(to: worksRelay)
            .disposed(by: disposeBag)

        favoriteWorkRelay.asObservable()
            .map(dependency.realmRepository.favorite(work:))
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    break
                case .failure:
                    // TODO: Error handling
                    break
                }
            }).disposed(by: disposeBag)

        unfavoriteWorkRelay.asObservable()
            .map(\.id)
            .map(dependency.realmRepository.unFavorite(workId:))
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    break
                case .failure:
                    // TODO: Error handling
                    break
                }
            }).disposed(by: disposeBag)
            
    }

    func showWork(work: Work) {
        dependency.router.transition(to: .work(work))
    }

    // Input
    private let viewWillAppearRelay = PublishRelay<Void>()
    func viewWillAppear() {
        viewWillAppearRelay.accept(())
    }
    private let viewDidLoadRelay = PublishRelay<Void>()
    func viewDidLoad() {
        viewDidLoadRelay.accept(())
    }
    private let refreshRelay = PublishRelay<Void>()
    func refresh() {
        refreshRelay.accept(())
    }
    private let favoriteWorkRelay = PublishRelay<Work>()
    func favoriteWork(work: Work) {
        favoriteWorkRelay.accept(work)
    }
    private let unfavoriteWorkRelay = PublishRelay<Work>()
    func unfavoriteWork(work: Work) {
        unfavoriteWorkRelay.accept(work)
    }

    // Output
    private let worksRelay = BehaviorRelay<[Work]>(value: [])
    var works: Driver<[Work]> {
        worksRelay.asDriver()
    }
}
