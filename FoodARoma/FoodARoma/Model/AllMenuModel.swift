//
//  AllMenuModel.swift
//  FoodARoma
//
//  Created by alan on 2023-07-05.
//

import Foundation

struct AllMenuModel : Codable {
    var Message : String
    var AllMenu: [allMenu]
}

// MARK: - AllMenu
struct allMenu : Codable {
    var menu_id : Int
    var menu_Time, menu_Cat, menu_Price,menu_Name,menu_Dec,avg_Rating,total_Ratings: String
    var menu_Photo: String?
    var menu_photo_Data : Data?
    var menu_quantity : Int?
    var ratings : [Ratings]
    
    mutating func addImgeData (imageData : Data){
        menu_photo_Data = imageData
    }
    mutating func addMenuQuantity (qData : Int){
        menu_quantity = qData
    }
}

struct Ratings : Codable{
    var comment, rating: String
    var date_Time, customer_Name: String?
}

struct AllRatingsModeldata : Codable {
    var Message : String
    var Rating : [Ratings]
}
