//
//  LoginModel.swift
//  FoodARoma
//
//  Created by Alan S Mathew on 2023-06-15.
//

import Foundation


struct LoginModel : Codable {
    var Auth : String
    var message : String
    var userID : Int?
    var userType : String?
    var name : String?
}

struct AddMenuModel : Codable {
    var Message : String
}
