//
//  ArrivalViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-08-09.
//

import UIKit
import PanModal
import Alamofire
import SwiftyJSON

class ArrivalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        arrivaldismissed = true
    }
    @IBAction func confirmArrival(_ sender: Any) {
        
        var datetime = ActiveOrders!.pickup_time
        var status = ActiveOrders!.is_accepted! + ",Arrived"
        let param = [
            "Mode" : "UpdateOrder",
            "OrderId":"\(ActiveOrders!.OrderId)",
            "is_accepted": status,
            "pickup_time" : datetime
        ]
        
        AF.request( Constants().BASEURL + Constants.APIPaths().AddOrder, method: .post, parameters: param, encoder: .json).response{
            response in

         switch response.result {
          case .success(let responseData):
             if JSON(responseData)["Message"] == "success"{
                 self.dismiss(animated: true)
             }
             else{
                 self.showAlert(title: "Something went wrong!", content: "unfotunatly there was something wrong with the request. please try again later.")
                 print(JSON(responseData))
             }

          case .failure(let error):
              print("error--->",error)
        }
      }

        self.dismiss(animated: true)
    }
    

}

extension ArrivalViewController: PanModalPresentable {

    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(400)
    }

    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(20)
    }
}
