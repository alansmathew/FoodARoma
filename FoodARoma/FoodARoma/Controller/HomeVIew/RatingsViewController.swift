//
//  RatingsViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-03.
//

import UIKit

class RatingsViewController: UIViewController {

    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var backofbackbuttomView: UIView!
    @IBOutlet weak var postButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        
        postButton.layer.cornerRadius = 12
        postButton.layer.shadowColor = UIColor(red: 0.07, green: 0.36, blue: 0.18, alpha: 1).cgColor;
        postButton.layer.shadowOffset = CGSize(width: 0, height: 7)
        postButton.layer.shadowOpacity = 0.57;
        postButton.layer.shadowRadius = 10;
        backbutton.layer.cornerRadius = backbutton.frame.width / 2
        backbutton.layer.masksToBounds = true
        backofbackbuttomView.layer.shadowColor = UIColor.black.cgColor;
        backofbackbuttomView.layer.shadowOffset = CGSize(width: 0, height: 5)
        backofbackbuttomView.layer.shadowOpacity = 0.20;
        backofbackbuttomView.layer.shadowRadius = 10;
        
        reviewTextView.layer.cornerRadius = 10
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.10).cgColor


        // Do any additional setup after loading the view.
    }
    
    
}

