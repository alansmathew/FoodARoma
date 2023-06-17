//
//  MoreViewController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-12.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
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
    override func viewWillAppear(_ animated: Bool) {
        let useremail = UserDefaults.standard.string(forKey: "USEREMAIL")
        if let email = useremail{
            userLabel.text = email
        }
        else{
            userLabel.text = "No user"
        }
        
    }
    @IBAction func signoutCLick(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "USERTYPE")
        UserDefaults.standard.removeObject(forKey: "USERID")
        UserDefaults.standard.removeObject(forKey: "USEREMAIL")
    }
}
