////
////  RatingViewControllerTest.swift
////  FoodARomaTests
////
////  Created by Anu Benoy on 2023-07-27.
////
//
//import XCTest
//@testable import FoodARoma
//
//class RatingsControllerTests: XCTestCase {
//
//    var ratingsViewController: RatingsViewController!
//    var mockAPIManager: CustomAPIManagerProtocol = MockAPIManager()
//    var mockLoader: MockLoader!
//    var mockAlertHandler: MockAlertHandler!
//
//    override func setUp() {
//        super.setUp()
//
//        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
//        ratingsViewController = storyboard.instantiateViewController(withIdentifier: "RatingsViewController") as? RatingsViewController
//        ratingsViewController.loadViewIfNeeded()
//
//        mockAPIManager = MockAPIManager()
//        ratingsViewController.apiManager = mockAPIManager
//
//        mockLoader = MockLoader()
//        ratingsViewController.loader = mockLoader
//
//        mockAlertHandler = MockAlertHandler()
//        ratingsViewController.alertHandler = mockAlertHandler
//    }
//
//    override func tearDown() {
//        ratingsViewController = nil
//        mockAPIManager = nil
//        mockLoader = nil
//        mockAlertHandler = nil
//        super.tearDown()
//    }
//
//    func testRatingButtonClick() {
//        // Simulate rating button click with ratingData = 3
//        let ratingButton = UIButton()
//        ratingButton.titleLabel?.text = "3"
//        ratingsViewController.ratingButtonClick(ratingButton)
//
//        // Verify that the ratingData is updated to 3
//        XCTAssertEqual(ratingsViewController.ratingData, 3)
//
//        // Verify that the rating stars images are updated accordingly
//        for (index, imageView) in ratingsViewController.ratingStars.enumerated() {
//            if index < 3 {
//                XCTAssertEqual(imageView.image, UIImage(systemName: "star.fill"))
//            } else {
//                XCTAssertEqual(imageView.image, UIImage(systemName: "star"))
//            }
//        }
//    }
//
//    func testPostReplayButtonEmptyReview() {
//        // Simulate post reply button click with an empty review
//        ratingsViewController.reviewTextView.text = ""
//        ratingsViewController.postReplayButton(UIButton())
//
//        // Verify that the alert is shown with the correct title and message
//        XCTAssertTrue(mockAlertHandler.showAlertCalled)
//        XCTAssertEqual(mockAlertHandler.title, "Empty fields")
//        XCTAssertEqual(mockAlertHandler.message, "Please enter some honest review inorder to post your comment.")
//    }
//
//    func testPostReplayButtonSuccess() {
//        // Simulate post reply button click with valid review and a successful API call
//        ratingsViewController.reviewTextView.text = "This is a great app!"
//        UserDefaults.standard.set("userID123", forKey: "USERID") // Set a dummy user ID
//        ratingsViewController.postReplayButton(UIButton())
//
//        // Verify that the API manager's sendRatingData function is called
//        XCTAssertTrue(mockAPIManager.sendRatingDataCalled)
//
//        // Verify that the loader is shown and then hidden after the API call
//        XCTAssertTrue(mockLoader.showCalled)
//        XCTAssertTrue(mockLoader.hideCalled)
//
//        // Verify that the view controller is dismissed after a successful API call
//        XCTAssertFalse(ratingsViewController.isBeingPresented)
//    }
//
//    func testPostReplayButtonFailure() {
//        // Simulate post reply button click with valid review and a failed API call
//        ratingsViewController.reviewTextView.text = "This is a great app!"
//        mockAPIManager.shouldSucceed = false
//        ratingsViewController.postReplayButton(UIButton())
//
//        // Verify that the API manager's sendRatingData function is called
//        XCTAssertTrue(mockAPIManager.sendRatingDataCalled)
//
//        // Verify that the loader is shown and then hidden after the API call
//        XCTAssertTrue(mockLoader.showCalled)
//        XCTAssertTrue(mockLoader.hideCalled)
//
//        // Verify that the alert is shown with the correct title and message after a failed API call
//        XCTAssertTrue(mockAlertHandler.showAlertCalled)
//        XCTAssertEqual(mockAlertHandler.title, "Failed")
//        XCTAssertEqual(mockAlertHandler.message, "An error occurred while sending the rating.")
//    }
//
//    // Add more test cases to cover other functionalities in the RatingsViewController class
//    // ...
//
//}
