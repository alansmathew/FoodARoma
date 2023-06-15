//
//  MoreViewController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-12.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        if let userType = UserDefaults.standard.string(forKey: "USERTYPE"){
            print("user found")
        }
        else{
            let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                present(viewC, animated: true)
        }
    }
}
