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
        
        let homeVC = HomeViewController(viewModel: HomeViewModel())
        homeVC.tabBarItem.title = "一覧"
        homeVC.tabBarItem.tag = 1
        homeVC.tabBarItem.image = UIImage(named: "document")

        let userVC = UserViewController(viewModel: UserViewModel())
        userVC.tabBarItem.title = "お気に入り"
        userVC.tabBarItem.tag = 2
        userVC.tabBarItem.image = UIImage(named: "favorite")

        setViewControllers([homeVC, userVC], animated: true)
    }
}
