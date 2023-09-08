//
//  ViewController+Alert.swift.swift
//  StreamFlexSystems
//
//  Created by Илья Крылов on 08.09.2023.
//

import UIKit


extension UIViewController {
    
    func showAlert(title: String, message: String, actionTitle: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            completion?()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
