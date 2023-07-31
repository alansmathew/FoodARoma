//
//  OrderTableViewCell.swift
//  FoodARoma
//
//  Created by alan on 2023-07-29.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var orderQ: UILabel!
    @IBOutlet weak var orderName: UILabel!
    @IBOutlet weak var orderPrice: UILabel!
    @IBOutlet weak var orderimageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
