//
//  Constants.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-15.
//

import Foundation
 
struct Constants {
    let BASEURL = "https://vddnh1wo04.execute-api.us-east-2.amazonaws.com/development/"
    let IMAGEUPLOADURL = "https://fatmfgkz40.execute-api.us-east-2.amazonaws.com/dev/foodaroma-image-storage/"
    let IMAGEURL = "https://sexbz25x03.execute-api.us-east-2.amazonaws.com/v1/foodaroma-image-storage?file="
    
    struct APIPaths{
        let loginPath = "user/auth"
        let fetchMenu = "menu/add"
        let AddOrder = "order/add"
    }

}
