//
//  ResturentOrdersController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-15.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView

class ResturentOrdersController: UIViewController {

    @IBOutlet weak var ResturentCurrentOrdersTable: UITableView!
    
    private var loading : (NVActivityIndicatorView,UIView)?
    var AllActiveOrders : [OrderHistories]? = [OrderHistories]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ResturentCurrentOrdersTable.delegate = self
        ResturentCurrentOrdersTable.dataSource = self
        ResturentCurrentOrdersTable.register(UINib(nibName: "ResturentOrderscell", bundle: nil), forCellReuseIdentifier: "ResOrderIdentifier")
        ResturentCurrentOrdersTable.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyCellIdentifier")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllOrders()
    }
    
    private func fetchAllOrders(){
        loading = customAnimation()
        loadingProtocol(with: loading! ,true)
        let params : [String : String] = [
                "Mode" : "fetchMenu"
            ]
        
        AF.request((Constants().BASEURL + Constants.APIPaths().fetchMenu), method: .post, parameters:params, encoder: .json).responseData { response in
            switch response.result{
            case .success(let data):
//                                    print(JSON(data))
                let decoder = JSONDecoder()
                do{
                    let jsonData = try decoder.decode(AllMenuModel.self, from: data)
                    AllMenuDatas = jsonData
                    
                    for x in 0..<(AllMenuDatas?.AllMenu.count ?? 0){
                        if let imageName = AllMenuDatas?.AllMenu[x].menu_Photo {
                            AF.request( Constants().IMAGEURL+imageName,method: .get).response{ response in

                             switch response.result {
                              case .success(let responseData):
                                
                                 if (JSON(responseData)["message"]=="Internal server error"){
                                     print("NO data comming")
                                 }
                                 else{
                                     AllMenuDatas?.AllMenu[x].addImgeData(imageData: responseData!)
                                 }
                              case .failure(let error):
                                  print("error--->",error)
                              }
                          }
                        }
                    }
                    
                }
                catch{
                    print(response.result)
                    self.loadingProtocol(with: self.loading! ,false)
                    print("decoder error")
                }
                
            case .failure(let error):
                self.loadingProtocol(with: self.loading! ,false)
                self.showAlert(title: "network intrepsion", content: "Something went wrong! please try again after some time")
                print(error)
            }
        }
        
        
        let paramss : [String : String] = [
                "Mode" : "listNotCompletedOrders"
            ]

        AF.request((Constants().BASEURL + Constants.APIPaths().AddOrder), method: .post, parameters:paramss, encoder: .json).responseData { response in
            switch response.result{
            case .success(let data):
                print(JSON(data))
                let decoder = JSONDecoder()
                do{
                    
                    let jsonData = try decoder.decode(OrderhistoryModel.self, from: data)
                    self.AllActiveOrders = jsonData.histories
                    
//                    self.ResturentCurrentOrdersTable.reloadData()
                    self.loadingProtocol(with: self.loading! ,false)

                }
                catch{
                    print(response.result)
                    self.loadingProtocol(with: self.loading! ,false)
                    print("decoder error")
                }

            case .failure(let error):
                self.loadingProtocol(with: self.loading! ,false)
                self.showAlert(title: "network intrepsion", content: "Something went wrong! please try again after some time")
                print(error)
            }
        }
    }
    
    func updateAllActiveOrderWithImages(){
        for x in 0..<(AllActiveOrders?.count ?? 0){
            for y in 0..<AllActiveOrders[x].Orders{
                
            }
        }
        
    }

}


extension ResturentOrdersController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Int(AllActiveOrders?.count ?? 0) == 0 {
            return 1
        }else{
            return Int(AllActiveOrders?.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ResturentCurrentOrdersTable.dequeueReusableCell(withIdentifier: "ResOrderIdentifier", for: indexPath) as! ResturentOrderscell
        if let orders = AllActiveOrders, orders.count > 0 {
            
        }
        else{
            print("cell empty")
            let cell = ResturentCurrentOrdersTable.dequeueReusableCell(withIdentifier: "emptyCellIdentifier", for: indexPath) as! EmptyTableViewCell
            return cell
        }
        return cell
    }
    
}

extension ResturentOrdersController : UITableViewDelegate {
}
