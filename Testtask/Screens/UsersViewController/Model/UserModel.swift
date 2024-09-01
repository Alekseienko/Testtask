//
//  UserModel.swift
//  Testtask
//
//  Created by Alekseienko on 01.09.2024.
//

import UIKit

// Model representing a user
struct UserModel: Identifiable {
    // Unique identifier for the user
    let id: Int
    // Name of the user
    let name: String
    // Email address of the user
    let email: String
    // Phone number of the user
    let phone: String
    // Job position or title of the user
    let position: String
    // Registration timestamp for when the user was registered (could be a Unix timestamp)
    let registrationTimestamp: Int
    // Photo of the user
    let photo: UIImage
}
