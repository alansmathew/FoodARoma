//
//  CustomOrderHistoryTableViewCell.swift
//  FoodARoma
//
//  Created by alan on 2023-08-04.
//

import UIKit

class CustomOrderHistoryTableViewCell: UITableViewCell {


    @IBOutlet weak var itemLeftCountLabel: UILabel!
    @IBOutlet weak var imageSet3View: UIView!
    @IBOutlet weak var imageSet3: UIImageView!
    @IBOutlet weak var imageSet2: UIImageView!
    @IBOutlet weak var imageSet1: UIImageView!
    @IBOutlet weak var bottomItemsView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var itemsCountBottomLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
