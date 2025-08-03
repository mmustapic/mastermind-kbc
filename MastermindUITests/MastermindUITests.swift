//
//  MastermindUITests.swift
//  MastermindUITests
//
//  Created by Marco Mustapic on 02/08/2025.
//

import XCTest

final class MastermindUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testWin() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        app.textFields["inputView0"].tap()
        app.textFields["inputView0"].typeText("A")
        app.textFields["inputView1"].tap()
        app.textFields["inputView1"].typeText("B")
        app.textFields["inputView2"].tap()
        app.textFields["inputView2"].typeText("C")
        app.textFields["inputView3"].tap()
        app.textFields["inputView3"].typeText("D")

        XCTAssertTrue(app.staticTexts["answerText"].waitForExistence(timeout: 20.0))
        XCTAssertEqual(app.staticTexts["answerText"].label, "Answer was ABCD")
        XCTAssertEqual(app.staticTexts["statusText"].label, "You Won!")
        XCTAssertEqual(app.buttons["playAgainButton"].label, "Play again")
    }

    @MainActor
    func testLose() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
        app.textFields["inputView0"].tap()
        app.textFields["inputView0"].typeText("W")
        app.textFields["inputView1"].tap()
        app.textFields["inputView1"].typeText("X")
        app.textFields["inputView2"].tap()
        app.textFields["inputView2"].typeText("Y")
        app.textFields["inputView3"].tap()
        app.textFields["inputView3"].typeText("Z")

        XCTAssertTrue(app.staticTexts["answerText"].waitForExistence(timeout: 20.0))
        XCTAssertEqual(app.staticTexts["answerText"].label, "Answer was ABCD")
        XCTAssertEqual(app.staticTexts["statusText"].label, "You Lost!")
        XCTAssertEqual(app.buttons["playAgainButton"].label, "Play again")
    }
}
