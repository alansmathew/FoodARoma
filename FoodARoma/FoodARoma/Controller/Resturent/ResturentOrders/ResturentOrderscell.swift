//
//  ResturentOrderscell.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-15.
//

import UIKit

class ResturentOrderscell: UITableViewCell {

    @IBOutlet weak var backgrounddView: UIView!
    @IBOutlet weak var itemsBackgroundView: UIView!
    @IBOutlet weak var imageSet1: UIImageView!
    @IBOutlet weak var imageset2: UIImageView!
    @IBOutlet weak var imageset3: UIImageView!
    @IBOutlet weak var imageset3View: UIView!
    @IBOutlet weak var arrivalStatusView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgrounddView.layer.cornerRadius = 29
        
        let corners = UIRectCorner(arrayLiteral: [
            UIRectCorner.topLeft,
            UIRectCorner.bottomRight
        ])

        let cornerRadii = CGSize(
            width: 20.0,
            height: 20.0
        )

        let maskPath = UIBezierPath(
            roundedRect: itemsBackgroundView.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )

        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = itemsBackgroundView.bounds

        itemsBackgroundView.layer.mask = maskLayer
        arrivalStatusView.layer.cornerRadius = arrivalStatusView.frame.width / 2
        imageset3View.layer.cornerRadius = imageset3View.frame.width / 2
        imageSet1.layer.borderWidth = 1
        imageSet1.layer.cornerRadius = imageSet1.frame.width / 2
        imageSet1.layer.borderColor = UIColor.white.cgColor
        imageset2.layer.borderWidth = 1
        imageset2.layer.cornerRadius = imageset2.frame.width / 2
        imageset2.layer.borderColor = UIColor.white.cgColor
        
        imageset3View.layer.shadowColor = UIColor(red: 0.07, green: 0.36, blue: 0.18, alpha: 1).cgColor;
        imageset3View.layer.shadowOffset = CGSize(width: 0, height: 3)
        imageset3View.layer.shadowOpacity = 0.57;
        imageset3View.layer.shadowRadius = 5;
        
//        mainImageView.layer.cornerRadius = mainImageView.frame.width / 2
//        mainImageView.layer.shadowColor = UIColor(red: 0.07, green: 0.36, blue: 0.18, alpha: 1).cgColor;
//        mainImageView.layer.shadowOffset = CGSize(width: 0, height: 7)
//        mainImageView.layer.shadowOpacity = 0.57;
//        mainImageView.layer.shadowRadius = 10;
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    

        // Configure the view for the selected state
    }
    
}
