//
//  CartViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-29.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var cartTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        
        cartTableView.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderHistoryIdentifier")
    }
    
    func showDeleteWarning(for indexPath: IndexPath) {

        let alert = UIAlertController(title: "Delete Menu ?", message: "Deleteion of a menu will cause issue while orderig. if there is anyone trying to order this menu at this time of deletion might still get through.", preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DispatchQueue.main.async {
                
            }
        }

        //Add the actions to the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        //Present the alert controller
        present(alert, animated: true, completion: nil)
    }


}

extension CartViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modifyAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
             DispatchQueue.main.async {
                 self.showDeleteWarning(for: indexPath)
             }

             success(true)
         })

         modifyAction.image = UIImage(named: "delete")
         modifyAction.backgroundColor = .red

         return UISwipeActionsConfiguration(actions: [modifyAction])
    
    }
    
}


extension CartViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "orderHistoryIdentifier", for: indexPath) as! OrderTableViewCell
        
        return cell
        
    }
    
}
