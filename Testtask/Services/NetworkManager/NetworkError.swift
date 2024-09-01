//
//  NetworkError.swift
//  Testtask
//
//  Created by Alekseienko on 01.09.2024.
//

import Foundation

/// An enum representing the various errors that can occur during network operations.
enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidID
    case noData
    case decodingError
    /// The server returned an error with a specific status code.
    case serverError(statusCode: Int)
    case noInternetConnection
    case unknownError
    
    /// A user-friendly description of the error.
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .invalidID:
            return "The user ID is invalid."
        case .noData:
            return "No data was received from the server."
        case .decodingError:
            return "Failed to decode the response from the server."
        case .serverError(let statusCode):
            return "Server returned an error with status code \(statusCode)."
        case .noInternetConnection:
            return "No internet connection is available."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
