//
//  MoreViewController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-12.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var nouserView: UIView!
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
        nouserView.isHidden = false
        
    }
    
    override func viewDidLayoutSubviews() {
        if let userType = UserDefaults.standard.string(forKey: "USERTYPE"){
            nouserView.isHidden = true
            let useremail = UserDefaults.standard.string(forKey: "USEREMAIL")
            let nameData =  UserDefaults.standard.string(forKey: "NAME")
            if let email = useremail, let name = nameData{
                nouserView.isHidden = true
                useremailLabel.text = email
                userLabel.text = name
            }
        }
        else{
            nouserView.isHidden = false
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        let useremail = UserDefaults.standard.string(forKey: "USEREMAIL")
        let nameData =  UserDefaults.standard.string(forKey: "NAME")
        if let email = useremail, let name = nameData{
            nouserView.isHidden = true
            useremailLabel.text = email
            userLabel.text = name
        }
        else{
            nouserView.isHidden = false
            userLabel.text = "No user"
        }
    }
    
    @IBAction func notificationClick(_ sender: Any) {
    }
    
    @IBAction func termsClick(_ sender: Any) {
    }
    
    @IBAction func logoutClick(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "USERTYPE")
        UserDefaults.standard.removeObject(forKey: "USERID")
        UserDefaults.standard.removeObject(forKey: "USEREMAIL")
        UserDefaults.standard.removeObject(forKey: "NAME")
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
            UserDefaults.standard.synchronize()
        }
        nouserView.isHidden = false
    }
    @IBAction func loginClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
            let viewC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            present(viewC, animated: true)
    }
    
}
