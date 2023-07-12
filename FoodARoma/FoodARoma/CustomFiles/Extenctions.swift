//
//  Extenctions.swift
//  FoodARoma
//
//  Created by alan on 2023-07-04.
//
import Foundation
import UIKit


extension UIViewController {
    func showAlert(title : String, content : String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
          
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        }))
         
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
}

