//
//  Globals.swift
//  FoodARoma
//
//  Created by alan on 2023-07-29.
//

import Foundation
import CoreLocation


//                home
let llatitude = 43.47653453726806
let llongitude = -80.53817017597704

// collage
//let llatitude = 43.48054744327771
//let llongitude = -80.51884224725556
let distanceThreshold: CLLocationDistance = 200.0


var arrivaldismissed = false
var goingtoPay = false 
var didAddNewItem = false
var CartOrders : [allMenu]? = [allMenu]()
var bevMenuGlobal : [allMenu]? = [allMenu]()

var AllMenuDatas : AllMenuModel?
var ActiveOrders : ActiveOrderModel?

func saveFetchCartData(fetchData : Bool = true){
    if fetchData{
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
            print("No data found in UserDefaults for the key 'CARTDATA'")
        }
    }
    else{
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

func updateActiveOrderStatus(saveData : Bool = true){
    if saveData{
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(ActiveOrders)

            // Store the encoded data in UserDefaults
            UserDefaults.standard.set(encodedData, forKey: "ACTIVEORDER")

            // Synchronize UserDefaults to save the data immediately (optional)
            UserDefaults.standard.synchronize()
        } catch {
            print("Error encoding model: \(error)")
        }
        
    }else{
        if let encodedData = UserDefaults.standard.data(forKey: "ACTIVEORDER") {
            do {
                // Create an instance of JSONDecoder
                let decoder = JSONDecoder()

                // Decode the data back into your model
                ActiveOrders = try decoder.decode(ActiveOrderModel.self, from: encodedData)
                print("initial Fetch -- >  \(ActiveOrders)")
            } catch {
                print("Error decoding model: \(error)")
            }
        } else {
            print("No data found in UserDefaults for the key 'ACTIVEORDER'")
        }
  
    }
}

func isLocationWithinDistance(latitude: Double, longitude: Double, targetLocation: CLLocation, distance: CLLocationDistance) -> Bool {
    let sourceLocation = CLLocation(latitude: latitude, longitude: longitude)
    let targetLocation = targetLocation
    
    let distanceInMeters = sourceLocation.distance(from: targetLocation)
    return distanceInMeters <= distance
}
