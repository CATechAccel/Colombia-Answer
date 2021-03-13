//
//  UIViewController+.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import UIKit

extension UIViewController {
    var forefrontViewController: UIViewController {
        func find(from base: UIViewController) -> UIViewController {
            switch base {
            case let base as UINavigationController:
                guard let top = base.topViewController else { return base }
                return find(from: top)
            case let base as UITabBarController:
                if let selected = base.selectedViewController {
                    return find(from: selected)
                }
                else if let top = base.moreNavigationController.topViewController {
                    return find(from: top)
                } else {
                    return base
                }
            default:
                if let presented = base.presentedViewController, !presented.isBeingDismissed {
                    return find(from: presented)
                } else {
                    return base
                }
            }
        }

        return find(from: self)
    }
    
    func showRetryAlert(with error: Error, retryHandler: @escaping () -> ()) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            retryHandler()
        })
        present(alertController, animated: true)
    }
}
