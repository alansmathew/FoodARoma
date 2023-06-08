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
        self.performSegue(withIdentifier: "InitialHomeScreenSegue", sender: nil)
    }
}

