//
//  CommentTableViewCell.swift
//  FoodARoma
//
//  Created by alan on 2023-07-03.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var commentLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
