//
//  AuthManager.swift
//  SmartPark
//
//  Created by Max on 9/5/2569 BE.
//

import Foundation
import Observation

@Observable
class AuthManager {
    var isAuthenticated = false
    var currentUser: UserProfile?
    var isLoading = false

    static let availableAccounts = [
        UserProfile(name: "Thanutham Chonsongkram", email: "thanutham.c@ku.th"),
        UserProfile(name: "Chanotai Mukdakul", email: "chanotai.m@ku.th")
    ]

    func signIn(with profile: UserProfile) {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.currentUser = profile
            self.isAuthenticated = true
            self.isLoading = false
        }
    }

    func signOut() {
        currentUser = nil
        isAuthenticated = false
    }
}
