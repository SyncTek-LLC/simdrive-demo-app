//
//  RootView.swift
//  simdrive-demo-app
//

import SwiftUI

struct RootView: View {
    @State private var signedInEmail: String? = nil

    var body: some View {
        if let email = signedInEmail {
            DashboardView(email: email, onLogout: {
                signedInEmail = nil
            })
        } else {
            SignInView(onSignIn: { email in
                signedInEmail = email
            })
        }
    }
}

#Preview {
    RootView()
}
