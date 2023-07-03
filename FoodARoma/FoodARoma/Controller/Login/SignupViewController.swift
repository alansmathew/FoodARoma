//
//  SignupViewController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-12.
//

import UIKit
import Alamofire

class SignupViewController: UIViewController {

    @IBOutlet weak var emailVIew: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmPassword: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func BackButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
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
    @IBAction func signupButtonPress(_ sender: UIButton) {
        let username = usernameTextField.text!
        let psd = passwordTextfield.text!
        let cpsd = confirmPasswordTextField.text!
        
        if psd != cpsd {
            showAlert(title: "Password dosent match", content: "Both the password entered are not matching. Please double check and try again.")
        }
        else{
            let params : [String : String] = [
                  "Username": username,
                  "Password": psd,
                  "Mode": "Registration",
                  "Phone": "",
                  "Photo": ""
                ]
            AF.request((Constants().BASEURL + Constants.APIPaths().loginPath), method: .post, parameters:params, encoder: .json).responseData { response in
                switch response.result{
                case .success(let data):
                    
                    let decoder = JSONDecoder()
                    do{
                        let jsonData = try decoder.decode(RegistrationModel.self, from: data)
                        if jsonData.message == "sucess" {
                        
                            UserDefaults.standard.set("customer", forKey: "USERTYPE")
                            UserDefaults.standard.set(jsonData.userID!, forKey: "USERID")
                            UserDefaults.standard.set(username, forKey: "USEREMAIL")
                            self.dismiss(animated: true)
                            self.navigationController?.popToRootViewController(animated: true)
            
                        }
                        else{
                            self.showAlert(title: "Failed", content: jsonData.message)
                        }
                    
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


