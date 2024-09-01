//
//  SignUpError.swift
//  Testtask
//
//  Created by Alekseienko on 31.08.2024.
//

import Foundation

/// Enum representing different errors that can occur during the sign-up process.
enum SignUpError: Error {
    /// Error indicating that image compression failed.
    case imageCompressionFailed
    
    /// Error indicating that a required position was not selected.
    case missingPosition
    
    /// Error indicating that an image required for registration is missing.
    case missingImage
    
    /// Error indicating that one or more fields in the sign-up form are invalid or empty.
    case invalidFields
    
    /// Error indicating a network-related issue, with a specific error message.
    case networkError(String)
    
    /// Provides a user-friendly description of the error.
    ///
    /// - Returns: A localized string describing the error.
    var description: String {
        switch self {
        case .imageCompressionFailed:
            return "There was an error compressing the image. Please try again."
        case .missingPosition:
            return "You must select a position before signing up."
        case .missingImage:
            return "An image is required for registration."
        case .invalidFields:
            return "One or more fields are invalid or empty. Please check your input and try again."
        case .networkError(let errorMessage):
            return "A network error occurred: \(errorMessage). Please check your connection and try again."
        }
    }
}
