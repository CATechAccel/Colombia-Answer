//
//  MainRouter.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import UIKit

enum RoutingDestination {
    case work(Work)
}

protocol MainRouting: AnyObject {
    func transition(to destination: RoutingDestination)
}

final class MainRouter: MainRouting {
    let container: UITabBarController

    init(container: UITabBarController) {
        self.container = container
    }

    func transition(to destination: RoutingDestination) {
        switch destination {
        case .work(let work):
            let viewModel = WorkViewModel(work: work)
            let controller = WorkViewController(viewModel: viewModel)
            container.forefrontViewController.present(controller, animated: true)
        }
    }
}
