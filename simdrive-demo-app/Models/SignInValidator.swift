//
//  SignInValidator.swift
//  simdrive-demo-app
//
//  Pure validation logic so it can be unit-tested without UI.
//

import Foundation

enum SignInResult: Equatable {
    case success(email: String)
    case validationError(message: String)
}

struct SignInValidator {
    /// Validates sign-in inputs. Local mock — any non-empty email + non-empty
    /// password "signs in". Empty password produces a validation error.
    static func validate(email: String, password: String) -> SignInResult {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            return .validationError(message: "Email is required")
        }
        if password.isEmpty {
            return .validationError(message: "Password is required")
        }
        return .success(email: trimmedEmail)
    }
}
