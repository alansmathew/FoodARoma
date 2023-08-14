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

    @IBOutlet weak var bottomViewAddCart: UIView!
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
    
    private func setupUI(){
        if let userType = UserDefaults.standard.string(forKey: "USERTYPE"){
            if userType == "restaurant"{
                bottomViewAddCart.isHidden = true
            }
        }
        
        
        if let selectedOrder = SelectedOrder {
            menuName.text = selectedOrder.menu_Name
            menuDec.text = selectedOrder.menu_Dec
            menuPrice.text = "$ "+selectedOrder.menu_Price
            menuTime.text = selectedOrder.menu_Time + " Min"
            menuRating.text = selectedOrder.avg_Rating
            totalNumberReview.text = selectedOrder.total_Ratings
            
            if let photodata = selectedOrder.menu_photo_Data {
                pitzzaImageView.image = UIImage(data: photodata, scale:1)
            }else{
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
    
    func loadImageInCellbev(cellData : BeverageMenuCollectionViewCell, cellImageName : String?, indexOfloading : Int){
        if let imageName = cellImageName {
            AF.request( Constants().IMAGEURL+imageName,method: .get).response{ response in

             switch response.result {
              case .success(let responseData):
                
                 if (JSON(responseData)["message"]=="Internal server error"){
                     print("NO data comming")
                     cellData.bevImageVew.image = UIImage(named: "imagebackground")
                     
                 }
                 else{
                    cellData.bevImageVew.image = UIImage(data: responseData!, scale:1)
                     bevMenuGlobal?[indexOfloading].addImgeData(imageData: responseData!)
                 }
              case .failure(let error):
                  print("error--->",error)
              }
          }
        }
    }
    
    @IBAction func plusButton(_ sender: UIButton) {
        quantity += 1
        quantityLabel.text = "\(quantity)"
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success)
        
    }
    
    @IBAction func minusButton(_ sender: Any) {
        if quantity != 1 {
            quantity -= 1
            quantityLabel.text = "\(quantity)"
        }
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.success)
    }
    
    @IBAction func AddCommentClick(_ sender: UIButton) {
        performSegue(withIdentifier: "addcommentIdentifier", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "addcommentIdentifier", let nextViewController = segue.destination as? RatingsViewController {
            nextViewController.SelectedOrder = SelectedOrder
        }
    }
    
    @IBAction func addToCartClick(_ sender: UIButton) {
        
        if let cart = CartOrders {
            var tempIndex = 0
            var flags = false
            for x in cart{
                if x.menu_id == SelectedOrder!.menu_id{
                    
                    let feedbackGenerator = UINotificationFeedbackGenerator()
                    feedbackGenerator.notificationOccurred(.warning)
                    flags = true
                    
                    let alert = UIAlertController(title: "Already in Cart", message: "The item that you wants to add is already in the cart. Do you want to replace the item or addthe quantity to the same product", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Replace", style: .destructive, handler: { _ in
                        let quantity = Int(self.quantityLabel.text ?? "1")!
                        self.SelectedOrder?.addMenuQuantity(qData: quantity)
                        CartOrders?[tempIndex] = self.SelectedOrder!
                        didAddNewItem = true
                        saveFetchCartData(fetchData: false)
                        let feedbackGenerator = UINotificationFeedbackGenerator()
                        feedbackGenerator.notificationOccurred(.success)
                        self.navigationController?.popViewController(animated: true)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Add", style: UIAlertAction.Style.default, handler: { _ in
                        let defaultQuantity = x.menu_quantity
                        let selectedquantity = Int(self.quantityLabel.text ?? "1")!
                        let newQuantity = defaultQuantity! + selectedquantity
                        self.SelectedOrder?.addMenuQuantity(qData: newQuantity)
                        CartOrders?[tempIndex] =  self.SelectedOrder!
                        saveFetchCartData(fetchData: false)
                        let feedbackGenerator = UINotificationFeedbackGenerator()
                        feedbackGenerator.notificationOccurred(.success)
                        self.navigationController?.popViewController(animated: true)
                    }))
                     
                    DispatchQueue.main.async {
                        self.present(alert, animated: false, completion: nil)
                    }
                    
                    break
                }
                else{
                    tempIndex += 1
                }
               
            }
            if !flags{
                let quantity = Int(quantityLabel.text ?? "1")!
                SelectedOrder?.addMenuQuantity(qData: quantity)
                if let order = SelectedOrder {
                    CartOrders?.append(order)
                    saveFetchCartData(fetchData: false)
                    didAddNewItem = true
                    let feedbackGenerator = UINotificationFeedbackGenerator()
                    feedbackGenerator.notificationOccurred(.success)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else{
            let quantity = Int(quantityLabel.text ?? "1")!
            SelectedOrder?.addMenuQuantity(qData: quantity)
            if let order = SelectedOrder {
                CartOrders?.append(order)
                saveFetchCartData(fetchData: false)
                didAddNewItem = true
                let feedbackGenerator = UINotificationFeedbackGenerator()
                feedbackGenerator.notificationOccurred(.success)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    @IBAction func viewArClicked(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "BuildOwnViewController") as! BuildOwnViewController
        viewC.alreadyHaveAr = true
        if let sel = SelectedOrder {
            if sel.menu_Name == "Custom Pizza"{
                print("wohaaa")
                viewC.ArString = sel.menu_Dec
            }
        }

        navigationController?.pushViewController(viewC, animated: true)
    }
    
    
}

extension OrderDetailsViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bevMenuGlobal?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bevCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeBeverageIdentifier", for: indexPath) as! BeverageMenuCollectionViewCell
        if let bevmenu = bevMenuGlobal?[indexPath.row] {
            if let menuPhotoData = bevmenu.menu_photo_Data {
                cell.bevImageVew.image = UIImage(data: menuPhotoData, scale:1)
            }
            else{
                loadImageInCellbev(cellData: cell, cellImageName: bevmenu.menu_Photo, indexOfloading: indexPath.row)
            }
            cell.moneyLabel.text = "$ "+(bevmenu.menu_Price)
        }
        return cell
    }
    
}

extension OrderDetailsViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        let viewC = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as! OrderDetailsViewController
        viewC.SelectedOrder = bevMenuGlobal?[indexPath.row]
        navigationController?.pushViewController(viewC, animated: true)
    }
    
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
            cell.customerNameLabel.text = ratings[indexPath.row].customer_Name
            
            let cellRatingimages = [cell.star1image,cell.star2image,cell.star3image,cell.star4image,cell.star5image]
            for x in 0...4{
                
                if Double(x) < Double(ratings[indexPath.row].rating) ?? 0{
                    cellRatingimages[x]!.image = UIImage(systemName: "star.fill")
                }
                else{
                    cellRatingimages[x]!.image = UIImage(systemName: "star")
                }
            }
            
            let fittingSize = CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height)
            let size = cell.contentView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
            let celllHeight = size.height
            
            cellHeight += size.height
            contentHeight.constant = cellHeight + 60
            return cell
        }
        else{
            let cell = commentsTable.dequeueReusableCell(withIdentifier: "emptyCellIdentifier", for: indexPath) as! EmptyTableViewCell
            cellHeight += cell.layer.frame.height
            contentHeight.constant = cellHeight
            return cell
        }
        
        
    }
    
}

extension OrderDetailsViewController : UITableViewDelegate {
}
