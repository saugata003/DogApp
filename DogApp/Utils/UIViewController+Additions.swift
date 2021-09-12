//
//  UIViewController+Additions.swift
//  DogApp
//
//  Created by Saugata on 08/09/21.
//

import UIKit
import MBProgressHUD
extension UIViewController {
    func alert(message: String, title: String = "", completion: (() -> Swift.Void)? = nil) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: completion)
        }
    }
    func showProgressHUD(_ currentView: UIView? = nil, _ message: String = "") {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            DispatchQueue.main.async {
                MBProgressHUD.showAdded(to: self.view, animated: true)
            }
        }
    }
    func hideProgressHUD(_ currentView: UIView? = nil) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}
