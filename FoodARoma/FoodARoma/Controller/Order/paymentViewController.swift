//
//  paymentViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-08-08.
//

import UIKit
import PanModal
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

class paymentViewController: UIViewController {

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var itemTotalLabel: UILabel!

    
    @IBOutlet weak var backofCardView: UIView!
    @IBOutlet var cardNumberTextField: PaddedTextField!
    @IBOutlet var nameTextField: PaddedTextField!
    @IBOutlet var expiryTextField: PaddedTextField!
    @IBOutlet var cvvTextField: PaddedTextField!
    
    var parms : [String: Any]? = [String: Any]()
    private var loading : (NVActivityIndicatorView,UIView)?
    var price : Double = 0.00

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        backofCardView.layer.cornerRadius = 10
        
        if let valueForKey = parms?["total_price"] as? String {
            let ttol = Double(valueForKey)!
            itemTotalLabel.text = "$ " + String(format: "%.2f", price)
            taxLabel.text = "$ " + String(format: "%.2f", price * 0.13)
            totalLabel.text = "$ " + String(format: "%.2f", price * 1.13)
        }
    }
    
    
    func generateRandomTransactionID(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var transactionID = ""
        
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<characters.count)
            let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            transactionID.append(character)
        }
        
        return transactionID
    }
    
    @IBAction func ConfirmPayment(_ sender: UIButton) {
        
        guard let cardNumber = cardNumberTextField.text, !cardNumber.isEmpty else {
            showAlert(message: "Card number is required")
            return
        }
        
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(message: "Name is required")
            return
        }
        
        guard let expiry = expiryTextField.text, !expiry.isEmpty else {
            showAlert(message: "Expiry date is required")
            return
        }
        
        guard let cvv = cvvTextField.text, !cvv.isEmpty else {
            showAlert(message: "CVV is required")
            return
        }
        
        
        let arrda = [4242424242424242,4000056655665556,5555555555554444,2223003122003222]
        
        sleep(1)
        
        var flag = true
        for x in arrda {
            if "\(x)" == cardNumberTextField.text{
                flag = false
                break
            }
        }
        if flag {
            return
            showAlert(message: "not valid card")
        }
        
        do {
            goingtoPay = true
            loading = customAnimation()
            loadingProtocol(with: loading! ,true)
            
            let randomTransactionID = generateRandomTransactionID(length: 22)
            parms?["transaction_id"] = randomTransactionID
            print(parms)
            
            let jsonData = try JSONSerialization.data(withJSONObject: parms, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
            print(Constants().BASEURL + Constants.APIPaths().AddOrder)
            AF.request(Constants().BASEURL + Constants.APIPaths().AddOrder, method: .post, parameters: parms, encoding: JSONEncoding.default).responseData {
                (response) in

                self.loadingProtocol(with: self.loading! ,false)

                switch (response.result) {
                case .success:
                    if (JSON(response.data)["Message"]=="success"){
                        let orderID = Int("\(JSON(response.data)["OrderId"])")
                        if let orderid = orderID{
                            ActiveOrders = ActiveOrderModel(OrderId: orderid, pickup_time: self.parms!["pref_time"] as! String, is_accepted: "Not Accepted", CartOrders: CartOrders!)
                            print(ActiveOrders)
                            CartOrders?.removeAll()

                            saveFetchCartData(fetchData: false)
                            updateActiveOrderStatus()
                            let feedbackGenerator = UINotificationFeedbackGenerator()
                            feedbackGenerator.notificationOccurred(.success)

                            self.dismiss(animated: true)
                        }
                        else{
                            self.showAlert(title: "Something went wrong!", content: "unfotunatly there was something wrong with the request. please try again later.")
                            print("error in orderid or array")
                            let feedbackGenerator = UINotificationFeedbackGenerator()
                            feedbackGenerator.notificationOccurred(.error)

                        }

                    }
                    else{
                        self.showAlert(title: "Something went wrong!", content: "unfotunatly there was something wrong with the request. please try again later.")
                        print(JSON(response.data!))
                    }
//                                print(JSON(response.data!))

                case .failure(let error):
                    print("error --> \(error)")
                }
            }

        } catch {
            print("Error converting params to JSON: \(error)")
            self.loadingProtocol(with: self.loading! ,false)
        }
        
        
    }
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension paymentViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(470)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(20)
    }
}
