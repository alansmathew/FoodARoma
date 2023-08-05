//
//  CustomAPIManagerProtocol.swift
//  FoodARomaTests
//
//  Created by Anu Benoy on 2023-07-26.
//


import Foundation

protocol CustomAPIManagerProtocol {
    func sendRatingData(params: [String: Any], completion: @escaping (Result<Data, Error>) -> Void)
}

