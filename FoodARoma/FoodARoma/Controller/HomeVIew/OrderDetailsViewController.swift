//
//  OrderDetailsViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-02.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var pitzzaImageView: UIImageView!
    @IBOutlet weak var totalNumberReview: UILabel!
    @IBOutlet weak var RStar5: UIImageView!
    @IBOutlet weak var RStar4: UIImageView!
    @IBOutlet weak var rStar3: UIImageView!
    @IBOutlet weak var rStar2: UIImageView!
    @IBOutlet weak var rStar1: UIImageView!
    @IBOutlet weak var menuRating: UILabel!
    @IBOutlet weak var menuTime: UILabel!
    @IBOutlet weak var menuPrice: UILabel!
    @IBOutlet weak var menuDec: UILabel!
    @IBOutlet weak var menuName: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentsTable: UITableView!
    @IBOutlet weak var bevCollectionView: UICollectionView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var moreCommentsbutton: UIButton!
    
    var SelectedOrder : allMenu?
    
    var quantity = 1
    var cellHeight = 0.0
    
    var ratingStars : [UIImageView] = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        quantityLabel.text = "\(quantity)"
        print(SelectedOrder)
        
        bevCollectionView.delegate = self
        bevCollectionView.dataSource = self
        bevCollectionView.register(UINib(nibName: "BeverageMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeBeverageIdentifier")
        
        commentsTable.delegate = self
        commentsTable.dataSource = self
        
        commentsTable.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentReusableidentifier")
        commentsTable.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyCellIdentifier")
        
        topView.layer.cornerRadius = 20
        topView.layer.shadowColor = UIColor.black.cgColor;
        topView.layer.shadowOffset = CGSize(width: 0, height: 3)
        topView.layer.shadowOpacity = 0.12;
        topView.layer.shadowRadius = 20;
        
        ratingStars = [rStar1,rStar2,rStar3,RStar4,RStar5]
        
//        commentsTable.layoutIfNeeded()
//        print(commentsTable.contentSize.height)
//        print(cellHeight)
        setupUI()
    
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    internal func setupUI(){
        if let selectedOrder = SelectedOrder {
            menuName.text = selectedOrder.menu_Name
            menuDec.text = selectedOrder.menu_Dec
            menuPrice.text = "$ "+selectedOrder.menu_Price
            menuTime.text = selectedOrder.menu_Time + " Min"
            menuRating.text = selectedOrder.avg_Rating
            totalNumberReview.text = selectedOrder.total_Ratings
            
            if let imageName = selectedOrder.menu_Photo {
                AF.request( Constants().IMAGEURL+imageName,method: .get).response{ response in

                 switch response.result {
                  case .success(let responseData):
                    
                     if (JSON(responseData)["message"]=="Internal server error"){
                         print("NO data comming")
                         self.pitzzaImageView.image = UIImage(systemName: "photo.circle")
                         
                     }
                     else{
                         self.pitzzaImageView.image = UIImage(data: responseData!, scale:1)
                     }
                
                  case .failure(let error):
                      print("error--->",error)
                  }
              }
            }
            
            

            for x in 0...4{
                
                if Double(x) < Double(selectedOrder.avg_Rating) ?? 0{
                    ratingStars[x].image = UIImage(systemName: "star.fill")
                }
                else{
                    ratingStars[x].image = UIImage(systemName: "star")
                }
            }
            
            if Double(selectedOrder.total_Ratings) ?? 0.0 > 3.0 {
                moreCommentsbutton.isHidden = false
                let total = (Int(selectedOrder.total_Ratings) ?? 0) - 3
                moreCommentsbutton.setTitle("\(total)" + " more", for: .normal)
            }
            else{
                moreCommentsbutton.isHidden = true
            }
        }
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
    
    @IBAction func AddCommentClick(_ sender: UIButton) {
        performSegue(withIdentifier: "addcommentIdentifier", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "addcommentIdentifier", let nextViewController = segue.destination as? RatingsViewController {
            nextViewController.SelectedOrder = SelectedOrder
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
        if Int(SelectedOrder?.ratings.count ?? 0) ?? 1 == 0 {
            return 1
        }else{
            return Int(SelectedOrder?.ratings.count ?? 0) ?? 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let ratings = SelectedOrder?.ratings, ratings.count > 0{
            let cell = commentsTable.dequeueReusableCell(withIdentifier: "commentReusableidentifier", for: indexPath) as! CommentTableViewCell
            cell.commentLable.text = ratings[indexPath.row].comment
            
            let cellRatingimages = [cell.star1image,cell.star2image,cell.star3image,cell.star4image,cell.star5image]
            for x in 0...4{
                
                if Double(x) < Double(ratings[indexPath.row].rating) ?? 0{
                    cellRatingimages[x]!.image = UIImage(systemName: "star.fill")
                }
                else{
                    cellRatingimages[x]!.image = UIImage(systemName: "star")
                }
            }
            
            cellHeight += cell.layer.frame.height
            contentHeight.constant = cellHeight
            return cell
        }
        else{
            print("comes here")
            let cell = commentsTable.dequeueReusableCell(withIdentifier: "emptyCellIdentifier", for: indexPath) as! EmptyTableViewCell
            cellHeight += cell.layer.frame.height
            contentHeight.constant = cellHeight
            return cell
        }
        
        
    }
    
}

extension OrderDetailsViewController : UITableViewDelegate {
    
}
