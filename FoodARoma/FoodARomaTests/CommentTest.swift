//
//  CommentTest.swift
//  FoodARomaTests
//
//  Created by Anu Benoy on 2023-07-30.
//

import XCTest
@testable import FoodARoma

class CommentsViewControllerTests: XCTestCase {
    var viewController: CommentsViewController!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "HomeOrder", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "CommentsViewController") as? CommentsViewController
        _ = viewController.view // Load the view hierarchy
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    // Test the number of rows in the table view
    func testNumberOfRows() {
        let numberOfRows = viewController.tableView(viewController.Commentstableview, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 3)
    }

    // Test the content of the cells
    func testCellContent() {
        let cell1 = viewController.tableView(viewController.Commentstableview, cellForRowAt: IndexPath(row: 1, section: 0)) as! CommentTableViewCell
        XCTAssertEqual(cell1.commentLable.text, "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.")

        let cell2 = viewController.tableView(viewController.Commentstableview, cellForRowAt: IndexPath(row: 2, section: 0)) as! CommentTableViewCell
        XCTAssertEqual(cell2.commentLable.text, "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr,")
    }
}
