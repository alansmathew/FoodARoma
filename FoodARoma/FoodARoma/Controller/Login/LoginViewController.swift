//
//  LoginViewController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-12.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var GoogleView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    var loading : (NVActivityIndicatorView,UIView)?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.hideKeyboardWhenTappedAround()

    }
    
//    override func viewDidLayoutSubviews() {
//        loading = customAnimation()
//        loadingProtocol(with: loading! ,true)
//    }

    private func setupUI(){
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
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        loading = customAnimation()
        loadingProtocol(with: loading! ,true)
        
        let username = usernameText.text!
        let psd = passwordText.text!
//        let username = "alansmathew@icloud.com"
//        let psd = "12345678"
        
        let params : [String : String] = [
              "Username": username,
              "Password": psd,
              "Mode": "Login",
              "Phone": "",
              "Photo": ""
              ]

        print(params)
        print((Constants().BASEURL + Constants.APIPaths().loginPath))
        AF.request((Constants().BASEURL + Constants.APIPaths().loginPath), method: .post, parameters:params, encoder: .json).responseData { response in
            switch response.result{
            case .success(let data):
                
                let decoder = JSONDecoder()
                do{
                    print(JSON(data))
                    let jsonData = try decoder.decode(LoginModel.self, from: data)
                    if jsonData.Auth == "success" {
                        if let parsedData = jsonData.userType {
                            if parsedData == "customer"{
                                UserDefaults.standard.set("customer", forKey: "USERTYPE")
                                UserDefaults.standard.set(jsonData.userID!, forKey: "USERID")
                                UserDefaults.standard.set(username, forKey: "USEREMAIL")
                                
                                self.dismiss(animated: true)
                            }
                            else if parsedData == "restaurant"{
                                UserDefaults.standard.set("restaurant", forKey: "USERTYPE")
                                UserDefaults.standard.set(jsonData.userID!, forKey: "USERID")
                                UserDefaults.standard.set(username, forKey: "USEREMAIL")
                                let storyboard = UIStoryboard(name: "ResturentMain", bundle: nil)
                                let viewC = storyboard.instantiateViewController(withIdentifier: "ResturentNavigationView") as! ResturentNavigationView
                                UIApplication.shared.windows.first!.rootViewController = viewC
                            }
                        }
                        self.loadingProtocol(with: self.loading! ,false)
                    }
                    else{
                        self.showAlert(title: "Invalid Credentials", content: jsonData.message)
                        self.loadingProtocol(with: self.loading! ,false)
                    }
                    
                    let usertype = UserDefaults.standard.string(forKey: "USERTYPE")
                    let userid = UserDefaults.standard.string(forKey: "USERID")
                    print(usertype)
                    print(userid)
                }
                catch{
                    print("decoder error")
                    self.loadingProtocol(with: self.loading! ,false)
                }
                
            case .failure(let error):
                self.showAlert(title: "network intrepsion", content: "Something went wrong! please try again after some time")
                print(error)
                self.loadingProtocol(with: self.loading! ,false)
            }
        }
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
