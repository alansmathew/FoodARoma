//
//  OrderDetails.swift
//  FoodARomaTests
//
//  Created by Anu Benoy on 2023-07-30.
//

import XCTest
@testable import FoodARoma

//struct Ratings : Codable{
//    var comment, rating: String
//    var date_Time, customer_Name: String?
//}

class OrderDetailsViewControllerTests: XCTestCase {

    var viewController: OrderDetailsViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "OrderDetailsViewController") as? OrderDetailsViewController
        _ = viewController.view // Load the view hierarchy
        
        let rating1 = Ratings(comment: "Great!", rating: "4.5", date_Time: "2023-07-25", customer_Name: "John")
//        let rating2 = Ratings(comment: "Excellent!", rating: "5.0", date_Time: "2023-07-26", customer_Name: "Jane")

        // Assuming SelectedOrder is properly set in the view controller
        viewController.SelectedOrder = allMenu(
            menu_id: 1,
            menu_Time: "10 mins",
            menu_Cat: "Pizza",
            menu_Price: "12.99",
            menu_Name: "Pepperoni Pizza",
            menu_Dec: "Delicious pepperoni pizza.",
            avg_Rating: "4.8",
            total_Ratings: "35",
            menu_Photo: "pepperoni_pizza.jpg",
            ratings: [rating1]
        )
    }
//
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }


    // Test the UI setup
    func testUISetup() {

        // Create an instance of OrderDetailsViewController
        let orderDetailsViewController = OrderDetailsViewController()

//        // Set the SelectedOrder property manually
//        orderDetailsViewController.SelectedOrder = allMenu(menu_id: 1, menu_Time: "1.30", menu_Cat: "special", menu_Price: "10.99", menu_Name: "Pizza", menu_Dec: "Delicious pizza", avg_Rating: "4.5", total_Ratings: "20", ratings: <#[Ratings]#>)

        // Call the setupUI method
        orderDetailsViewController.setupUI()

        XCTAssertEqual(orderDetailsViewController.menuName.text, "Pizza")
        XCTAssertEqual(orderDetailsViewController.menuDec.text, "Delicious pizza")
        XCTAssertEqual(orderDetailsViewController.menuPrice.text, "10.99")
        XCTAssertEqual(orderDetailsViewController.menuTime.text, "1.30")
        XCTAssertEqual(orderDetailsViewController.menuRating.text, "4.5")
        XCTAssertEqual(orderDetailsViewController.totalNumberReview.text, "20")
    }

////    func testRatingStars() {
////        // Create an instance of OrderDetailsViewController
////        let orderDetailsViewController = OrderDetailsViewController()
////
////        // Set the SelectedOrder property manually
////        orderDetailsViewController.SelectedOrder = allMenu(menu_id: 1, menu_Time: "1.30", menu_Cat: "special", menu_Price: "10.99", menu_Name: "Pizza", menu_Dec: "Delicious pizza", avg_Rating: "4.5", total_Ratings: "20", ratings: <#[Ratings]#>)
////
////        // Test rating stars
////        func testRatingStars() {
////            let ratingStars = [viewController.rStar1, viewController.rStar2, viewController.rStar3, viewController.RStar4, viewController.RStar5]
////            for (index, starImageView) in ratingStars.enumerated() {
////                if let rating = Double(viewController.SelectedOrder?.avg_Rating ?? "0"), Double(index) < rating {
////                    XCTAssertEqual(starImageView?.image, UIImage(systemName: "star.fill"))
////                } else {
////                    XCTAssertEqual(starImageView?.image, UIImage(systemName: "star"))
////                }
////            }
////        }
////
////        // Test more comments button
////        func testMoreCommentsButton() {
////            if let totalRatings = Double(viewController.SelectedOrder?.total_Ratings ?? "0"), totalRatings > 3.0 {
////                XCTAssertFalse(viewController.moreCommentsbutton.isHidden)
////                let total = Int(totalRatings) - 3
////                XCTAssertEqual(viewController.moreCommentsbutton.title(for: .normal), "\(total) more")
////            } else {
////                XCTAssertTrue(viewController.moreCommentsbutton.isHidden)
////            }
////        }
////
////        // Test table view data source methods
////        func testTableViewDataSource() {
////            // Assuming SelectedOrder is properly set in the view controller
////            let tableView = viewController.commentsTable
////
////            // Test with no ratings
////            viewController.SelectedOrder?.ratings = []
////            tableView?.reloadData()
////            XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 1)
////
////            // Test with ratings
////            viewController.SelectedOrder?.ratings = [
////                //                      Ratings(comment: "Great!", rating: "4.5"),
////                //                      Ratings(comment: "Excellent!", rating: "5.0")
////            ]
////            tableView?.reloadData()
////            XCTAssertEqual(tableView?.numberOfRows(inSection: 0), 2)
////
////            // Test cell content
////            let cell1 = tableView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? CommentTableViewCell
////            XCTAssertEqual(cell1?.commentLable.text, "Great!")
////            XCTAssertEqual(cell1?.star1image.image, UIImage(systemName: "star.fill"))
////            XCTAssertEqual(cell1?.star2image.image, UIImage(systemName: "star.fill"))
////            XCTAssertEqual(cell1?.star3image.image, UIImage(systemName: "star.fill"))
////            XCTAssertEqual(cell1?.star4image.image, UIImage(systemName: "star.fill"))
////            XCTAssertEqual(cell1?.star5image.image, UIImage(systemName: "star"))
//        }
}

