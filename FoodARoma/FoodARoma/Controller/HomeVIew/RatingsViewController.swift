//
//  RatingsViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-03.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class RatingsViewController: UIViewController {

    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var backofbackbuttomView: UIView!
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var sButton1: UIButton!
    @IBOutlet weak var sButton2: UIButton!
    @IBOutlet weak var sButton3: UIButton!
    @IBOutlet weak var sButton4: UIButton!
    @IBOutlet weak var sButton5: UIButton!
    
    var ratingData = 4
    var SelectedOrder : allMenu?
    
    var loading : (NVActivityIndicatorView,UIView)?
    
    var ratingStars : [UIImageView] = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        reviewTextView.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        ratingStars = [star1,star2,star3,star4,star5]
        
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
        
        reviewTextView.text = "Write your honest review here."
        reviewTextView.textColor = UIColor.lightGray
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ratingButtonClick(_ sender: UIButton) {
        ratingData = Int(Double(sender.titleLabel?.text ?? "0") ?? 0)
        for x in 0...4{
            if Double(sender.titleLabel?.text ?? "0") ?? 0 > Double(x) {
                ratingStars[x].image = UIImage(systemName: "star.fill")
            }
            else{
                ratingStars[x].image = UIImage(systemName: "star")
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func sendRatingData(usrID : String){
        
        loading = customAnimation()
        loadingProtocol(with: loading! ,true)
        
        let name =  UserDefaults.standard.string(forKey: "NAME")!
        
        let params : [String : String] = [
            "Mode": "addRating",
            "Name" : name,
            "MenuId": "\(SelectedOrder!.menu_id)",
            "RegId": usrID,
            "Comments": reviewTextView.text!,
            "Rating": "\(ratingData)"
        ]
        
        print(params)
        
        
        AF.request((Constants().BASEURL + Constants.APIPaths().fetchMenu), method: .post, parameters:params, encoder: .json).responseData { response in
            switch response.result{
            case .success(let data):

                let decoder = JSONDecoder()
                do{
                    print(JSON(data))
                    let jsonData = try decoder.decode(AddMenuModel.self, from: data)
                    if jsonData.Message == "success" {
                        self.loadingProtocol(with: self.loading! ,false)
                        self.dismiss(animated: true)
                    }
                    else{
                        self.showAlert(title: "Failed", content: jsonData.Message)
                        self.loadingProtocol(with: self.loading! ,false)
                    }

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
    
    @IBAction func postReplayButton(_ sender: UIButton) {
        if !reviewTextView.text.isEmpty {
            if reviewTextView.text == "Write your honest review here." {
                showAlert(title: "Empty fields", content: "Please enter some honest review inorder to post your comment.")
            }
            else{
                if let userID = UserDefaults.standard.string(forKey: "USERID"){
                    sendRatingData(usrID: userID)
                }
                else{
                    let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
                    let viewC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    present(viewC, animated: true)
                }
            }
        }
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.view.frame.origin.y -= keyboardFrame.size.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    
}

extension RatingsViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        reviewTextView.scrollRangeToVisible(textView.selectedRange)
        if reviewTextView.textColor == UIColor.lightGray {
            reviewTextView.text = nil
            reviewTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if reviewTextView.text.isEmpty {
            reviewTextView.text = "Write your honest review here."
            reviewTextView.textColor = UIColor.lightGray
        }
    }
    
}

