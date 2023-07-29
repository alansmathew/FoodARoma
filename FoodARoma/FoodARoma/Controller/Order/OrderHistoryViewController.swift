//
//  OrderHistoryViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-29.
//

import UIKit

class OrderHistoryViewController: UIViewController {

    @IBOutlet weak var orderHistoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderHistoryTable.delegate = self
        orderHistoryTable.dataSource = self
        
        orderHistoryTable.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderHistoryIdentifier")
    }
    


}

extension OrderHistoryViewController : UITableViewDelegate{
    
    
}

extension OrderHistoryViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderHistoryTable.dequeueReusableCell(withIdentifier: "orderHistoryIdentifier", for: indexPath) as! OrderTableViewCell
        
        return cell
        
    }
    
}
