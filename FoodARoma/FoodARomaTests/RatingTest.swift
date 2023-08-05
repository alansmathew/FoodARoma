//
//  RatingTest.swift
//  FoodARomaTests
//
//  Created by Anu Benoy on 2023-07-25.
//

import XCTest
@testable import FoodARoma // Import your app's module here

class RatingsViewControllerTests: XCTestCase {
    
    var ratingsViewController: RatingsViewController!
    
    override func setUp() {
        super.setUp()
        
        // Initialize the view controller from the storyboard
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        ratingsViewController = storyboard.instantiateViewController(withIdentifier: "RatingsViewController") as? RatingsViewController
        ratingsViewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        ratingsViewController = nil
        super.tearDown()
    }
    
    
    // Test case for the ratingButtonClick function
    func testRatingButtonClickUpdatesStars() {
        // Set up initial state
        let expectedRatingData = 3
        let expectedStarCount = 3
        let ratingButton = UIButton()
        ratingButton.setTitle("\(expectedRatingData)", for: .normal)
        
        // Call the ratingButtonClick function
        ratingsViewController.ratingButtonClick(ratingButton)
        
        // Check if the correct number of stars is filled based on the selected rating
        for i in 0..<expectedStarCount {
            let starImage = ratingsViewController.ratingStars[i].image
            XCTAssertNotNil(starImage)
            XCTAssertEqual(starImage, UIImage(systemName: "star.fill"))
        }
        
        // Check if the remaining stars are not filled
        for i in expectedStarCount..<ratingsViewController.ratingStars.count {
            let starImage = ratingsViewController.ratingStars[i].image
            XCTAssertNotNil(starImage)
            XCTAssertEqual(starImage, UIImage(systemName: "star"))
        }
        
        // Check if the ratingData variable is updated
        XCTAssertEqual(ratingsViewController.ratingData, expectedRatingData)
    }
    
    // Test cases to test the behavior of the textViewDidBeginEditing and textViewDidEndEditing functions
    func testTextViewDidBeginEditing() {
           // Set up initial state
           ratingsViewController.reviewTextView.text = "Write your honest review here."
           ratingsViewController.reviewTextView.textColor = UIColor.lightGray
           
           // Call the textViewDidBeginEditing function
           ratingsViewController.textViewDidBeginEditing(ratingsViewController.reviewTextView)
           
           // Verify that the text view text is cleared and color is changed to black
           XCTAssertEqual(ratingsViewController.reviewTextView.text, "")
           XCTAssertEqual(ratingsViewController.reviewTextView.textColor, UIColor.black)
       }
    
    func testTextViewDidEndEditingWithEmptyText() {
            // Set up initial state with an empty review
            ratingsViewController.reviewTextView.text = ""
            ratingsViewController.reviewTextView.textColor = UIColor.black
            
            // Call the textViewDidEndEditing function
            ratingsViewController.textViewDidEndEditing(ratingsViewController.reviewTextView)
            
            // Verify that the text view text is reset and color is changed to light gray
            XCTAssertEqual(ratingsViewController.reviewTextView.text, "Write your honest review here.")
            XCTAssertEqual(ratingsViewController.reviewTextView.textColor, UIColor.lightGray)
        }
        
    func testTextViewDidEndEditingWithNonEmptyText() {
        // Set up initial state with a non-empty review
        let expectedReviewText = "This is a great app!"
        ratingsViewController.reviewTextView.text = expectedReviewText
        ratingsViewController.reviewTextView.textColor = UIColor.black
        
        // Call the textViewDidEndEditing function
        ratingsViewController.textViewDidEndEditing(ratingsViewController.reviewTextView)
        
        // Verify that the text view text remains the same and color is unchanged
        XCTAssertEqual(ratingsViewController.reviewTextView.text, expectedReviewText)
        XCTAssertEqual(ratingsViewController.reviewTextView.textColor, UIColor.black)
    }
    
//    func testPostReplayButtonSendsRatingData() {
//        // Set up initial state
//        let mockUserID = "mockUserID"
//        let expectedReviewText = "This is a great app!"
//        ratingsViewController.reviewTextView.text = expectedReviewText
//        let ratingButton = UIButton()
//        ratingButton.setTitle("5", for: .normal)
//        ratingsViewController.ratingButtonClick(ratingButton)
//
//        // Create an instance of the MockAPIManager
//        let mockAPIManager = MockAPIManager()
//
//        // Call the sendRatingData function with the mock API manager
//        ratingsViewController.sendRatingData(usrID: mockUserID)
//
//        // Verify that the sendRatingData function is called with the correct parameters
//        XCTAssertTrue(mockAPIManager.sendRatingDataCalled)
//        XCTAssertEqual(mockAPIManager.ratingParams?["MenuId"] as? Int, ratingsViewController.SelectedOrder?.menu_id)
//        XCTAssertEqual(mockAPIManager.ratingParams?["RegId"] as? String, mockUserID)
//        XCTAssertEqual(mockAPIManager.ratingParams?["Comments"] as? String, expectedReviewText)
//        XCTAssertEqual(mockAPIManager.ratingParams?["Rating"] as? Int, 5)
//    }

    

    
}

