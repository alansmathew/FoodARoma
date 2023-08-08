//
//  ActiveOrderModel.swift
//  FoodARoma
//
//  Created by alan on 2023-08-02.
//

import Foundation

struct ActiveOrderModel : Codable {
    let OrderId : Int
    var pickup_time : String
    var is_accepted : String?
    var CartOrders : [allMenu]
    
    mutating func updateOrderStatusinModel(Status : String?){
        is_accepted = Status
    }
    
    mutating func updateOrderTime(TimeData : String){
        pickup_time = TimeData
    }
}
