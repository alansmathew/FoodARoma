//
//  Globals.swift
//  FoodARoma
//
//  Created by alan on 2023-07-29.
//

import Foundation



var didAddNewItem = false
var CartOrders : [allMenu]? = [allMenu]()

func saveFetchCartData(fetchData : Bool = true){
    if fetchData{
//        let cartData = UserDefaults.standard.array(forKey: "CARTDATA")
//        if case let cart as [allMenu] =  cartData {
//            CartOrders = cart
//        }
//        print(CartOrders)
        
        if let encodedData = UserDefaults.standard.data(forKey: "CARTDATA") {
            do {
                // Create an instance of JSONDecoder
                let decoder = JSONDecoder()

                // Decode the data back into your model
                CartOrders = try decoder.decode([allMenu].self, from: encodedData)
            } catch {
                print("Error decoding model: \(error)")
            }
        } else {
            print("No data found in UserDefaults for the key 'myModelKey'")
        }
        
    }
    else{
//        let nameData =  UserDefaults.standard.object(forKey: "")
//        UserDefaults.standard.set("customer", forKey: "USERTYPE")
//        UserDefaults.standard.set(CartOrders, forKey: "CARTDATA")
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(CartOrders)

            // Store the encoded data in UserDefaults
            UserDefaults.standard.set(encodedData, forKey: "CARTDATA")

            // Synchronize UserDefaults to save the data immediately (optional)
            UserDefaults.standard.synchronize()
        } catch {
            print("Error encoding model: \(error)")
        }
    }
}
