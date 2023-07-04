//
//  OrderDetailsViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-02.
//

import UIKit

class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var bevCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    
    var quantity = 1
    var cellHeight = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quantityLabel.text = "\(quantity)"
        
        bevCollectionView.delegate = self
        bevCollectionView.dataSource = self
        bevCollectionView.register(UINib(nibName: "BeverageMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeBeverageIdentifier")
        
        commentsTable.delegate = self
        commentsTable.dataSource = self
        
        commentsTable.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentReusableidentifier")
        
        topView.layer.cornerRadius = 20
        topView.layer.shadowColor = UIColor.black.cgColor;
        topView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topView.layer.shadowOpacity = 0.12;
        topView.layer.shadowRadius = 20;
        
//        commentsTable.layoutIfNeeded()
//        print(commentsTable.contentSize.height)
//        print(cellHeight)
        
    }
    @IBAction func plusButton(_ sender: UIButton) {
        quantity += 1
        quantityLabel.text = "\(quantity)"
        
    }
    @IBAction func minusButton(_ sender: Any) {
        if quantity != 1 {
            quantity -= 1
            quantityLabel.text = "\(quantity)"
        }
    }
    

}

extension OrderDetailsViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bevCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeBeverageIdentifier", for: indexPath) as! BeverageMenuCollectionViewCell
        return cell
    }
    
    
}

extension OrderDetailsViewController : UICollectionViewDelegate{

}

extension OrderDetailsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTable.dequeueReusableCell(withIdentifier: "commentReusableidentifier", for: indexPath) as! CommentTableViewCell
        if indexPath.row == 1{
            cell.commentLable.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
            
        }
        if indexPath.row == 2 {
            cell.commentLable.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr,"
        }
        cellHeight += cell.layer.frame.height
        contentHeight.constant = cellHeight * 0.83
        
        
        return cell
    }
    
}

extension OrderDetailsViewController : UITableViewDelegate {
    
}
