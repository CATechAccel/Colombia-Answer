//
//  IndexTabViewController.swift
//  Colombia
//
//  Created by 化田晃平 on R 3/02/14.
//

import UIKit

final class TabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let router = MainRouter(container: self)

        let homeViewModel = HomeViewModel(
            dependency: .init(
                router: router,
                annictWorksRepository: .init(),
                realmRepository: .init()
            )
        )
        let homeVC = HomeViewController(viewModel: homeViewModel)
        homeVC.tabBarItem.title = "Home"
        homeVC.tabBarItem.image = #imageLiteral(resourceName: "document")

        let userViewModel = UserViewModel(
            dependency: .init(
                router: router,
                realmRepository: .init()
            )
        )
        let userVC = UserViewController(viewModel: userViewModel)
        userVC.tabBarItem.title = "User"
        userVC.tabBarItem.image = #imageLiteral(resourceName: "favorite")

        setViewControllers([homeVC, userVC], animated: true)
    }
}
