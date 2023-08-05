//
//  tempViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-03.
//

import UIKit
import NVActivityIndicatorView
import Alamofire
import SwiftyJSON

class CommentsViewController: UIViewController {
    

    private var loading : (NVActivityIndicatorView,UIView)?
    @IBOutlet weak var Commentstableview: UITableView!
    
    var allRatings : AllRatingsModeldata?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Commentstableview.delegate = self
        Commentstableview.dataSource = self
        
        Commentstableview.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentReusableidentifier")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAllComments()
    }
    
    func loadAllComments(){
        let params : [String : String] = [
                "Mode" : "fetchRating",
                "MenuId" : "1"
            ]
        
        AF.request((Constants().BASEURL + Constants.APIPaths().fetchMenu), method: .post, parameters:params, encoder: .json).responseData { response in
            switch response.result{
            case .success(let data):
                print(JSON(data))
                let decoder = JSONDecoder()
                do{
                    let jsonData = try decoder.decode(AllRatingsModeldata.self, from: data)
                    self.allRatings = jsonData
                    self.Commentstableview.reloadData()
                    
                }
                catch{
                    print(response.result)
//                    self.loadingProtocol(with: self.loading! ,false)
                    print("decoder error")
                }
                
            case .failure(let error):
//                self.loadingProtocol(with: self.loading! ,false)
                self.showAlert(title: "network intrepsion", content: "Something went wrong! please try again after some time")
                print(error)
            }
        }
    }

}
extension CommentsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRatings?.Rating.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Commentstableview.dequeueReusableCell(withIdentifier: "commentReusableidentifier", for: indexPath) as! CommentTableViewCell
       
        if let allRating = allRatings {
            cell.commentLable.text = allRating.Rating[indexPath.row].comment
            cell.customerNameLabel.text = allRating.Rating[indexPath.row].customer_Name
            
            let cellRatingimages = [cell.star1image,cell.star2image,cell.star3image,cell.star4image,cell.star5image]
            for x in 0...4{
                
                if Double(x) < Double(allRating.Rating[indexPath.row].rating) ?? 0{
                    cellRatingimages[x]!.image = UIImage(systemName: "star.fill")
                }
                else{
                    cellRatingimages[x]!.image = UIImage(systemName: "star")
                }
            }
            
            
        }


        return cell
    }
    
    
}


extension CommentsViewController : UITableViewDelegate{
    
}
