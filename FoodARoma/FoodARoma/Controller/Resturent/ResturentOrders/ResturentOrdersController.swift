//
//  ResturentOrdersController.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-15.
//

import UIKit

class ResturentOrdersController: UIViewController {

    @IBOutlet weak var ResturentCurrentOrdersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ResturentCurrentOrdersTable.delegate = self
        ResturentCurrentOrdersTable.dataSource = self
        
        
        ResturentCurrentOrdersTable.register(UINib(nibName: "ResturentOrderscell", bundle: nil), forCellReuseIdentifier: "ResOrderIdentifier")
    }

}

extension ResturentOrdersController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ResturentCurrentOrdersTable.dequeueReusableCell(withIdentifier: "ResOrderIdentifier", for: indexPath) as! ResturentOrderscell
        
        return cell
    }
    
}

extension ResturentOrdersController : UITableViewDelegate {
    
}
