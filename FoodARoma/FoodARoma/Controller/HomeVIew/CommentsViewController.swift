//
//  tempViewController.swift
//  FoodARoma
//
//  Created by alan on 2023-07-03.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var Commentstableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Commentstableview.delegate = self
        Commentstableview.dataSource = self
        
        Commentstableview.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentReusableidentifier")

        // Do any additional setup after loading the view.
    }


}
extension CommentsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Commentstableview.dequeueReusableCell(withIdentifier: "commentReusableidentifier", for: indexPath) as! CommentTableViewCell
        if indexPath.row == 1{
            cell.commentLable.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
            
        }
        if indexPath.row == 2 {
            cell.commentLable.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr,"
        }
        return cell
    }
    
    
}


extension CommentsViewController : UITableViewDelegate{
    
}
