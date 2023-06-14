//
//  SignupViewController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-12.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var emailVIew: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmPassword: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var backbutton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func setupUI(){
        emailVIew.layer.cornerRadius = 12
        passwordView.layer.cornerRadius = 12
        confirmPassword.layer.cornerRadius = 12
        continueButton.layer.cornerRadius = 12
        continueButton.layer.shadowColor = UIColor(red: 0.07, green: 0.36, blue: 0.18, alpha: 1).cgColor;
        continueButton.layer.shadowOffset = CGSize(width: 0, height: 7)
        continueButton.layer.shadowOpacity = 0.57;
        continueButton.layer.shadowRadius = 10;
        backbutton.layer.cornerRadius = backbutton.frame.width / 2
        backbutton.layer.masksToBounds = true
        testView.layer.shadowColor = UIColor.black.cgColor;
        testView.layer.shadowOffset = CGSize(width: 0, height: 5)
        testView.layer.shadowOpacity = 0.20;
        testView.layer.shadowRadius = 10;

    }

}


