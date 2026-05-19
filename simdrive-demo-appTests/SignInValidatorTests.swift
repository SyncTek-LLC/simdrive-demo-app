//
//  SignInValidatorTests.swift
//  simdrive-demo-appTests
//
//  Unit tests for the sign-in validation logic on `main` (the fixed version).
//

import XCTest
@testable import simdrive_demo_app

final class SignInValidatorTests: XCTestCase {

    func testEmptyPasswordReturnsValidationError() {
        let result = SignInValidator.validate(email: "you@example.com", password: "")
        XCTAssertEqual(result, .validationError(message: "Password is required"))
    }

    func testEmptyEmailReturnsValidationError() {
        let result = SignInValidator.validate(email: "", password: "hunter2")
        XCTAssertEqual(result, .validationError(message: "Email is required"))
    }

    func testWhitespaceOnlyEmailReturnsValidationError() {
        let result = SignInValidator.validate(email: "   ", password: "hunter2")
        XCTAssertEqual(result, .validationError(message: "Email is required"))
    }

    func testValidCredentialsReturnSuccess() {
        let result = SignInValidator.validate(email: "you@example.com", password: "hunter2")
        XCTAssertEqual(result, .success(email: "you@example.com"))
    }

    func testEmailIsTrimmedOnSuccess() {
        let result = SignInValidator.validate(email: "  you@example.com  ", password: "hunter2")
        XCTAssertEqual(result, .success(email: "you@example.com"))
    }
}
