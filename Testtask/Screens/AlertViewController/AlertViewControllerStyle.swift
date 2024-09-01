//
//  AlertViewControllerStyle.swift
//  Testtask
//
//  Created by Alekseienko on 31.08.2024.
//

import Foundation
import UIKit

/// Enum representing different styles of alerts that can be shown by the `AlertViewController`.
enum AlertViewControllerStyle {
    
    /// Alert style for when there is no internet connection.
    case internetConnection
    /// Alert style for successful user registration.
    case successfullyRegistered
    /// Alert style for when a user is already registered with the provided phone or email.
    case alreadyRegistered
    
    /// A descriptive message for the alert style.
    /// - Returns: A `String` describing the alert.
    var description: String {
        switch self {
        case .internetConnection: return "There is no internet connection"
        case .successfullyRegistered: return "User successfully registered"
        case .alreadyRegistered: return "User with this phone or email already exist"
        }
    }
    
    /// The title for the button shown in the alert.
    /// - Returns: A `String` representing the button title.
    var buttonTitle: String {
        switch self {
        case .internetConnection: return "Try again"
        case .successfullyRegistered: return "Got it"
        case .alreadyRegistered: return "Try again"
        }
    }
    
    /// The image associated with the alert style.
    /// - Returns: A `UIImage` representing the alert icon.
    var image: UIImage {
        switch self {
        case .internetConnection: return .networkErrorAlert
        case .successfullyRegistered: return .successfullyRegisteredAlert
        case .alreadyRegistered: return .emailRegisteredErrorAlert
        }
    }
    
    /// Indicates whether the alert can be dismissed by the user.
    /// - Returns: A `Bool` indicating if the alert is dismissible.
    var isDismissible: Bool {
        switch self {
        case .internetConnection: return false
        case .successfullyRegistered: return true
        case .alreadyRegistered: return true
        }
    }
}
