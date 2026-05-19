//
//  SignInView.swift
//  simdrive-demo-app
//
//  Minimal sign-in screen. Local mock auth only — no backend.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var validationError: String? = nil

    let onSignIn: (String) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("you@example.com", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .accessibilityIdentifier("email-field")

                    SecureField("Password", text: $password)
                        .textContentType(.password)
                        .accessibilityIdentifier("password-field")
                }

                if let validationError = validationError {
                    Section {
                        Text(validationError)
                            .foregroundColor(.red)
                            .accessibilityIdentifier("validation-error")
                    }
                }

                Section {
                    Button(action: signInTapped) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                    }
                    .accessibilityIdentifier("sign-in-button")
                }
            }
            .navigationTitle("Sign In")
        }
    }

    private func signInTapped() {
        // BUG (bug/empty-password-crash):
        // The validator used to short-circuit on empty password, but a careless
        // "let's grab the first character for analytics" refactor force-unwraps
        // password.first BEFORE we hand off to SignInValidator. When the user
        // taps Sign In with an empty password we crash with EXC_BAD_INSTRUCTION.
        // Fixed on main — see git log.
        let _ = password.first!  // 💥 crash on empty password

        let result = SignInValidator.validate(email: email, password: password)
        switch result {
        case .success(let email):
            validationError = nil
            onSignIn(email)
        case .validationError(let message):
            validationError = message
        }
    }
}

#Preview {
    SignInView(onSignIn: { _ in })
}
