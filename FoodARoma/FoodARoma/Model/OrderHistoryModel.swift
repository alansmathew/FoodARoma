//
//  OrderHistoryModel.swift
//  FoodARoma
//
//  Created by alan on 2023-08-05.
//

import Foundation

struct OrderhistoryModel :Codable {
    var histories : [OrderHistories]
}

struct OrderHistories : Codable {
    var is_accepted, user_name, datetime, total_price, special_note : String
    var order_id, user_id : Int
    var Orders : [OrderHistoriesOrders]
}


struct OrderHistoriesOrders : Codable {
    var order_dis, order_type : String
    var order_no, order_qty, order_id, indivorder_id : Int
    var order_name : String?
    var order_photo_data : Data?
    
    
    mutating func updateOrderName(orderName : String){
        order_name = orderName
    }
    
    mutating func updateOrderImage (orderImageData : Data){
        order_photo_data = orderImageData
    }
}
