//
//  OrderHistoryViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-29.
//

import UIKit

class OrderHistoryViewController: UIViewController {

    @IBOutlet weak var restofItemslabel: UILabel!
    @IBOutlet weak var orderPickuptimeLabel: UILabel!
    @IBOutlet weak var orderNumberOfitemsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderItemsLabel: UILabel!
    @IBOutlet weak var OrderIdLabel: UILabel!
    @IBOutlet weak var arravingView: UIView!
    @IBOutlet weak var imageset3View: UIView!
    
    @IBOutlet weak var imageSet3: UIImageView!
    @IBOutlet weak var imageSet2: UIImageView!
    @IBOutlet weak var imageSet1: UIImageView!
    @IBOutlet weak var itemsBAckgroundView: UIView!
    @IBOutlet weak var currentOrderView: UIView!
    @IBOutlet weak var orderHistoryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderHistoryTable.delegate = self
        orderHistoryTable.dataSource = self
        
        orderHistoryTable.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "orderHistoryIdentifier")
        setupUIOrder()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleActiveOrderTap(_:)))
        currentOrderView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(ActiveOrders)
        
        if let ActiveOrder = ActiveOrders {
            
            currentOrderView.isHidden = false
            imageSet1.isHidden = true
            imageSet2.isHidden = true
            imageSet3.isHidden = true
            imageset3View.isHidden = true
        
            
            switch ActiveOrder.CartOrders.count {
            case 1:
                imageSet1.isHidden = false
                imageSet1.image = UIImage(data: ActiveOrder.CartOrders[0].menu_photo_Data!)
                break
            case 2:
                imageSet1.isHidden = false
                imageSet1.image = UIImage(data: ActiveOrder.CartOrders[0].menu_photo_Data!)
                imageSet2.isHidden = false
                imageSet2.image = UIImage(data: ActiveOrder.CartOrders[1].menu_photo_Data!)
                break
            case 3:
                imageSet1.isHidden = false
                imageSet1.image = UIImage(data: ActiveOrder.CartOrders[0].menu_photo_Data!)
                imageSet2.isHidden = false
                imageSet2.image = UIImage(data: ActiveOrder.CartOrders[1].menu_photo_Data!)
                imageSet3.isHidden = false
                imageSet3.image = UIImage(data: ActiveOrder.CartOrders[2].menu_photo_Data!)
                break
            case 4...ActiveOrder.CartOrders.count :
                imageSet1.isHidden = false
                imageSet1.image = UIImage(data: ActiveOrder.CartOrders[0].menu_photo_Data!)
                imageSet2.isHidden = false
                imageSet2.image = UIImage(data: ActiveOrder.CartOrders[1].menu_photo_Data!)
                imageSet3.isHidden = false
                imageSet3.image = UIImage(data: ActiveOrder.CartOrders[2].menu_photo_Data!)
                imageset3View.isHidden = false
                restofItemslabel.text = "+ \(ActiveOrder.CartOrders.count - 3)"
                break
            default:
                print("switch case problem")
                break
            }
            
            OrderIdLabel.text = "ORDER ID #12000\(ActiveOrder.OrderId)"
            orderNumberOfitemsLabel.text = "\(ActiveOrder.CartOrders.count) Items"
            var tempitemNames = ""
            var dataIterations = 0
            for x in ActiveOrder.CartOrders {
                tempitemNames += x.menu_Name + " Q \(x.menu_quantity!)\n"
                if dataIterations > 2 {
                    tempitemNames += "more..."
                    break
                }
                dataIterations += 1
            }
            orderItemsLabel.text = tempitemNames
            
            if let outputDateString = Date().convertTo12HourFormat(dateString: ActiveOrder.pickup_time) {
                orderPickuptimeLabel.text = outputDateString
            } else {
                print("Invalid date string")
            }
        }
        else{
            currentOrderView.isHidden = true
        }
    }
    
    @objc func handleActiveOrderTap(_ gesture: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "OrderStoryboard", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "OrderHistoryDetailsViewController") as! OrderHistoryDetailsViewController
        viewC.ActiveOrderData = ActiveOrders
        navigationController?.pushViewController(viewC, animated: true)
    }
    
    private func setupUIOrder(){
        
        currentOrderView.layer.cornerRadius = 20
        currentOrderView.layer.borderWidth = 0.5
        currentOrderView.layer.borderColor = UIColor(named: "GreenColor")?.cgColor
        
        let corners = UIRectCorner(arrayLiteral: [
            UIRectCorner.topLeft,
            UIRectCorner.bottomRight
        ])

        let cornerRadii = CGSize(
            width: 20.0,
            height: 20.0
        )

        let maskPath = UIBezierPath(
            roundedRect: itemsBAckgroundView.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )

        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = itemsBAckgroundView.bounds

        itemsBAckgroundView.layer.mask = maskLayer
        arravingView.layer.cornerRadius = arravingView.frame.width / 2
        imageset3View.layer.cornerRadius = imageset3View.frame.width / 2
        imageSet1.layer.borderWidth = 1
        imageSet1.layer.cornerRadius = imageSet1.frame.width / 2
        imageSet1.layer.borderColor = UIColor.white.cgColor
        imageSet2.layer.borderWidth = 1
        imageSet2.layer.cornerRadius = imageSet2.frame.width / 2
        imageSet2.layer.borderColor = UIColor.white.cgColor
        
        imageset3View.layer.shadowColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1).cgColor;
        imageset3View.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageset3View.layer.shadowOpacity = 0.57;
        imageset3View.layer.shadowRadius = 5;
        
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
