//
//  CommentTableViewCell.swift
//  FoodARoma
//
//  Created by alan on 2023-07-03.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var star5image: UIImageView!
    @IBOutlet weak var star4image: UIImageView!
    @IBOutlet weak var star3image: UIImageView!
    @IBOutlet weak var star2image: UIImageView!
    @IBOutlet weak var star1image: UIImageView!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var commentLable: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
