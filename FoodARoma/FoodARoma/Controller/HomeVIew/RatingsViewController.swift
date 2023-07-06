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
        
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        reviewTextView.delegate = self
        
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
        
        reviewTextView.text = "Write your honest review here."
        reviewTextView.textColor = UIColor.lightGray
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func postReplayButton(_ sender: UIButton) {
        if !reviewTextView.text.isEmpty {
            if reviewTextView.text == "Write your honest review here." {
                showAlert(title: "Empty fields", content: "Please enter some honest review inorder to post your comment.")
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

