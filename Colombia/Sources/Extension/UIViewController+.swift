//
//  UIViewController+.swift
//  Colombia
//
//  Created by Takuma Osada on 2021/03/13.
//

import UIKit
extension UIViewController {
    func showRetryAlert(with error: Error, retryHandler: @escaping () -> ()) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Retry", style: .default) { _ in
            retryHandler()
        })
        present(alertController, animated: true)
    }
}
