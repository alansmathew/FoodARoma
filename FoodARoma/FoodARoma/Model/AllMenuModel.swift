//
//  AllMenuModel.swift
//  FoodARoma
//
//  Created by alan on 2023-07-05.
//

import Foundation

struct AllMenuModel : Codable {
    var AllMenu: [allMenu]
}

// MARK: - AllMenu
struct allMenu : Codable {
    var menu_Time, menu_Cat, menu_Price,menu_Name,menu_Dec: String
    var menu_Photo: String?
}
