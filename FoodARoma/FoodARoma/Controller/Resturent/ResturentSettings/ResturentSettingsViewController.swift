//
//  ResturentSettingsViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-09.
//

import UIKit

class ResturentSettingsViewController: UIViewController {
    
    @IBOutlet weak var arrowBackground: UIImageView!
    @IBOutlet weak var settingsBackground: UIStackView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var accounbackgroundView: UIView!
    @IBOutlet weak var useremailLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
        accounbackgroundView.layer.cornerRadius = 14
        arrowBackground.layer.cornerRadius = 8
        
        accounbackgroundView.layer.shadowColor = UIColor.black.cgColor;
        accounbackgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)
        accounbackgroundView.layer.shadowOpacity = 0.13;
        accounbackgroundView.layer.shadowRadius = 10.0;
        
        settingsBackground.layer.cornerRadius = 14
        settingsBackground.layer.masksToBounds = true
        
        
        
        let useremail = UserDefaults.standard.string(forKey: "USEREMAIL")
        if let email = useremail{
            useremailLabel.text = email
            let components = email.components(separatedBy: "@")
            userLabel.text = components.first
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClick(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "USERTYPE")
        UserDefaults.standard.removeObject(forKey: "USERID")
        UserDefaults.standard.removeObject(forKey: "USEREMAIL")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "MainNavigationViewController") as! MainNavigationViewController
        UIApplication.shared.windows.first!.rootViewController = viewC
    }

}
