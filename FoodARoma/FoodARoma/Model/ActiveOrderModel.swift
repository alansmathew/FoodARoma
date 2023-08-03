//
//  ActiveOrderModel.swift
//  FoodARoma
//
//  Created by alan on 2023-08-02.
//

import Foundation

struct ActiveOrderModel : Codable {
    let OrderId : Int
    let pickup_time : String
    let CartOrders : [allMenu]
}
