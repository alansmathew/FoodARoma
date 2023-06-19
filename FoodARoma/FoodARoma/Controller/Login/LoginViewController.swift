//
//  LoginViewController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-12.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var appleView: UIView!
    @IBOutlet weak var GoogleView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
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
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        let username = usernameText.text!
        let psd = passwordText.text!
//        let username = "alansmathew@icloud.com"
//        let psd = "12345678"
        
        let params : [String : String] = [
              "Username": username,
              "Password": psd,
              "Mode": "Login"
              ]
        
        AF.request((Constants().BASEURL + Constants.APIPaths().loginPath), method: .post, parameters:params, encoder: .json).responseData { response in
            switch response.result{
            case .success(let data):
                
                let decoder = JSONDecoder()
                do{
                    let jsonData = try decoder.decode(LoginModel.self, from: data)
                    if jsonData.Auth == "sucess" {
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
                    }
                    else{
                        self.showAlert(title: "Invalid Credentials", content: jsonData.message)
                    }
                    
                    let usertype = UserDefaults.standard.string(forKey: "USERTYPE")
                    let userid = UserDefaults.standard.string(forKey: "USERID")
                    print(usertype)
                    print(userid)
                }
                catch{
                    print("decoder error")
                }
                
            case .failure(let error):
                self.showAlert(title: "network intrepsion", content: "Something went wrong! please try again after some time")
                print(error)
            }
        }
    }
    
    
    
    func showAlert(title : String, content : String) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
          
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        }))
         
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
          
    }
}
