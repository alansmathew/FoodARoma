//
//  ResturentAddNewOrderViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-09.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON


class ResturentAddNewOrderViewController: UIViewController {
    
    let categories = ["special", "beverage", "menu"]
    let pickerView = UIPickerView()

    @IBOutlet weak var pizzaImage: UIImageView!
    @IBOutlet weak var prerTime: PaddedTextField!
    @IBOutlet weak var priceTExt: PaddedTextField!
    @IBOutlet weak var selectCat: PaddedTextField!
    @IBOutlet weak var addbuttonClick: UIButton!
    @IBOutlet weak var discriptionView: UITextView!
    @IBOutlet weak var menuName: UITextField!
    
    var imageData : UIImage? = UIImage()
    var imageName = ""
    
    var loading : (NVActivityIndicatorView,UIView)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectCat.inputView = pickerView
               
       // Assign the data source and delegate of the UIPickerView
        pickerView.dataSource = self
        pickerView.delegate = self
        discriptionView.delegate = self
        
        selectCat.inputView = pickerView
        
        
        discriptionView.delegate
        discriptionView.layer.cornerRadius = 10
        discriptionView.text = "Write the discription for you pizza."
        discriptionView.textColor = UIColor.lightGray
        
        self.hideKeyboardWhenTappedAround()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= keyboardFrame.size.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    
    @IBAction func AddMenuClick(_ sender: Any) {
        
        loading = customAnimation()
        loadingProtocol(with: loading! ,true)
        
        
        let image = imageData
        
        print(imageName)
        
        let urlString = Constants().IMAGEUPLOADURL+imageName
        let headers: HTTPHeaders = [
            "Content-Type": "image/png"
        ]
        
        let pngImageData = image!.pngData()
        
        if let imageData = pngImageData{
            
            
            AF.upload(imageData, to: urlString, method: .put, headers: headers)
                .responseJSON { response in
                    print(response)
                    
                    let imageurl = Constants().IMAGEURL+self.imageName
                    AF.request( imageurl ,method: .get).response{ response in

                     switch response.result {
                      case .success(let responseData):
                        
                         if (JSON(responseData)["message"]=="Internal server error"){
                             self.loadingProtocol(with: self.loading! ,false)
                             self.showAlert(title: "Failed", content: "There was some problem while trying to upload the image. Please try again!")
                         }
                         else{
                             
                             let params : [String : String] = [
                                 "Mode" : "addMenu",
                                 "MenuName" : self.menuName.text!,
                                 "Photo" : self.imageName,
                                 "PrepTime" : self.prerTime.text!,
                                 "Price" : self.priceTExt.text!,
                                 "Desc" : self.discriptionView.text!,
                                 "Cat" : self.selectCat.text!
                           ]
                             
                             print(params)
                             AF.request((Constants().BASEURL + Constants.APIPaths().fetchMenu), method: .post, parameters:params, encoder: .json).responseData { response in
                                 switch response.result{
                                 case .success(let data):
                     
                                     let decoder = JSONDecoder()
                                     do{
                                         print(JSON(data))
                                         let jsonData = try decoder.decode(AddMenuModel.self, from: data)
                                         if jsonData.Message == "sucess"{
                                             self.loadingProtocol(with: self.loading! ,false)
                                             self.navigationController?.popViewController(animated: true)
                                         }
                                         else{
                                             self.loadingProtocol(with: self.loading! ,false)
                                             self.showAlert(title: "Failed", content: jsonData.Message)
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
                      case .failure(let error):
                          print("error--->",error)
                      }
                    }
                }
        }
        else{
            self.loadingProtocol(with: self.loading! ,false)
            
            showAlert(title: "Select Image", content: "Please select an image to continue. There is no selection of image available in this context. Please select an image inorder to upload the images to the server and display it for the users")
        }
        
    }
    
    @IBAction func imagepickerButtonClick(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
        
    }
    
}

extension ResturentAddNewOrderViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\(info)")
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            pizzaImage.image = image
            imageData = image
            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                imageName = imageURL.lastPathComponent
                print("Image Name: \(imageName)")
            }
        }
        picker.dismiss(animated: true)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ResturentAddNewOrderViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        discriptionView.scrollRangeToVisible(textView.selectedRange)
        if discriptionView.textColor == UIColor.lightGray {
            discriptionView.text = nil
            discriptionView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if discriptionView.text.isEmpty {
            discriptionView.text = "Write the discription for you pizza."
            discriptionView.textColor = UIColor.lightGray
        }
    }
}

class PaddedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = 12 // Adjust the corner radius as needed
            layer.masksToBounds = true
    }
}

extension ResturentAddNewOrderViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // We are using a single component in the picker view
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count // Return the number of categories
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row] // Return the category name for each row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = categories[row]
        selectCat.text = selectedCategory // Set the selected category in the text field
    }
}
