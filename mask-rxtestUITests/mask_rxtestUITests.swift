//
//  mask_rxtestUITests.swift
//  mask-rxtestUITests
//
//  Created by Steven Zeng on 2020/5/19.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import XCTest

class mask_rxtestUITests: XCTestCase {

  var app: XCUIApplication!
  var tableView: XCUIElement!

  override func setUpWithError() throws {
    app = XCUIApplication()
    app.launch()
    tableView = app.tables["tableView"]
    continueAfterFailure = false
  }

  func testTableViewDisplayData() throws {
    sleep(2)
    XCTAssertTrue(tableView.cells.count > 0)
    let cell = tableView.cells.element(matching: .cell, identifier: "0")
    let nameLabel = cell.children(matching: .staticText).element(matching: .staticText, identifier: "nameLabel")
    let countLabel = cell.children(matching: .staticText).element(matching: .staticText, identifier: "countLabel")
    XCTAssertNotNil(nameLabel.label)
    XCTAssertNotEqual(nameLabel.label, "")
    XCTAssertNotNil(countLabel.label)
    XCTAssertNotEqual(countLabel.label, "")
  }

}
