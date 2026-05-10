//
//  UserProfile.swift
//  SmartPark
//

import Foundation

struct UserProfile {
    let name: String
    let email: String

    var initial: String {
        String(name.prefix(1))
    }
}
