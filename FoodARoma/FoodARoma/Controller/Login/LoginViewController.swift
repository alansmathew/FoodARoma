//
//  LoginViewController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-12.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var GoogleView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }


    func setupUI(){
        usernameView.layer.cornerRadius = 12
        passwordView.layer.cornerRadius = 12
        appleView.layer.cornerRadius = 12
        GoogleView.layer.cornerRadius = 12
        continueButton.layer.cornerRadius = 12
        continueButton.layer.shadowColor = UIColor(red: 0.07, green: 0.36, blue: 0.18, alpha: 1).cgColor;
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 7)
        continueButton.layer.shadowOpacity = 0.57;
        continueButton.layer.shadowRadius = 10;
    }
}
