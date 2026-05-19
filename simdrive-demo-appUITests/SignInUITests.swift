//
//  SignInUITests.swift
//  simdrive-demo-appUITests
//
//  UI flow: launch -> fill email + password -> tap sign-in -> see dashboard.
//  Also exercises the validation-error path that the demo features on `main`.
//

import XCTest

final class SignInUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSuccessfulSignInNavigatesToDashboard() {
        let app = XCUIApplication()
        app.launch()

        let emailField = app.textFields["email-field"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        emailField.tap()
        emailField.typeText("test@example.com")

        let passwordField = app.secureTextFields["password-field"]
        XCTAssertTrue(passwordField.exists)
        passwordField.tap()
        passwordField.typeText("hunter2")

        app.buttons["sign-in-button"].tap()

        let logoutButton = app.buttons["logout-button"]
        XCTAssertTrue(logoutButton.waitForExistence(timeout: 5),
                      "Expected dashboard logout button to appear after sign-in.")
    }

    func testEmptyPasswordShowsValidationError() {
        let app = XCUIApplication()
        app.launch()

        let emailField = app.textFields["email-field"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        emailField.tap()
        emailField.typeText("test@example.com")

        // Intentionally do not enter a password.
        app.buttons["sign-in-button"].tap()

        let validationError = app.staticTexts["validation-error"]
        XCTAssertTrue(validationError.waitForExistence(timeout: 3),
                      "Expected validation-error to appear when password is empty.")

        // Confirm we did not navigate.
        XCTAssertFalse(app.buttons["logout-button"].exists,
                       "Should not have navigated to dashboard on empty-password tap.")
    }
}
