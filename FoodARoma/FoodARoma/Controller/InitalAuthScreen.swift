//
//  ViewController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-04.
//

import UIKit

class InitalAuthScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sleep(1)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        saveFetchCartData()
        updateActiveOrderStatus(saveData: false)
        
        if let userType = UserDefaults.standard.string(forKey: "USERTYPE"){
            print("user found")
            if userType == "customer"{
                self.performSegue(withIdentifier: "InitialHomeScreenSegue", sender: nil)
            }
            else if userType == "restaurant"{
                let storyboard = UIStoryboard(name: "ResturentMain", bundle: nil)
                let viewC = storyboard.instantiateViewController(withIdentifier: "ResturentNavigationView") as! ResturentNavigationView
                UIApplication.shared.windows.first!.rootViewController = viewC
            }
        }
        else{
            self.performSegue(withIdentifier: "InitialHomeScreenSegue", sender: nil)
        }
        
        
        
//        let storyboard = UIStoryboard(name: "ResturentMain", bundle: nil)
//        let viewC = storyboard.instantiateViewController(withIdentifier: "ResturentNavigationView") as! ResturentNavigationView
//        UIApplication.shared.windows.first!.rootViewController = viewC
    }
}

