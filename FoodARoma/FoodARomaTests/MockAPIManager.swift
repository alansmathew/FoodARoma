//
//  MockAPIManager.swift
//  FoodARomaTests
//
//  Created by Anu Benoy on 2023-07-26.
//

import Foundation


import Foundation
import Alamofire
@testable import FoodARoma

class MockAPIManager: CustomAPIManagerProtocol {
    var sendRatingDataCalled = false
    var ratingParams: [String: Any]?
    var shouldSucceed = true

    func sendRatingData(params: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
        sendRatingDataCalled = true
        ratingParams = params

        if shouldSucceed {
            // Simulate a successful response with empty data
            completion(.success(Data()))
        } else {
            // Simulate a failure response with an error
            let error = NSError(domain: "MockAPIError", code: 500, userInfo: nil)
            completion(.failure(error))
        }
    }
}
