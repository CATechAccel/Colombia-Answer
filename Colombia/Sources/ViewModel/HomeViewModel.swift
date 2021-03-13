//
//  HomeViewModel.swift
//  Colombia
//
//  Created by 化田晃平 on R 3/02/25.
//

import RxCocoa
import RxSwift
import RxRelay

protocol HomeViewModelInput {
    var input: HomeViewModelInput { get }

    func viewDidLoad()
    func refresh()
    func showWork(work: Work)
}

protocol HomeViewModelOutput {
    var output: HomeViewModelOutput { get }

    var works: Driver<[Work]> { get }
}

struct HomeViewModel: HomeViewModelInput, HomeViewModelOutput {
    struct Dependency {
        var router: MainRouter
        var annictWorksRepository: AnnictWorksRepository
        var realmRepository: RealmRepository
    }

    private var dependency: Dependency
    private let disposeBag = DisposeBag()

    var input: HomeViewModelInput { self }
    var output: HomeViewModelOutput { self }

    init(dependency: Dependency) {
        self.dependency = dependency
        Observable.merge([
            viewDidLoadRelay.asObservable(),
            refreshRelay.asObservable(),
        ])
            .flatMap(dependency.annictWorksRepository.fetch)
            .map { $0.works.map(Work.init(entity:)) }
            .withLatestFrom(Observable.just(dependency.realmRepository.fetchFavoriteWorks())) { ($0, $1) }
            .map { works, favoriteWorks in
                let favoritedIds: [Int] = favoriteWorks.map(\.id)
                return works.map {
                    var work = $0
                    work.isFavorited = favoritedIds.contains($0.id)
                    return work
                }
            }
            .bind(to: worksRelay)
            .disposed(by: disposeBag)
    }

    func showWork(work: Work) {
        dependency.router.transition(to: .work(work))
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
