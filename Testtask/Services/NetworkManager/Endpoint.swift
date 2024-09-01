//
//  Endpoint.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import Foundation

/// An enum representing the various API endpoints in the application.
enum Endpoint {
    /// Fetch a paginated list of users.
    case fetchUsers(page: Int, count: Int)
    /// Register a new user.
    case registerUser
    /// Fetch a list of available positions.
    case fetchPositions
    /// Fetch an authentication token.
    case fetchToken
    /// Fetch details of a user by their ID.
    case getUserBy(id: Int)
    /// The base URL for the API.
    var baseURL: String {
        return "https://frontend-test-assignment-api.abz.agency/api/v1"
    }
    
    /// The path component of the URL for each endpoint.
    var path: String {
        switch self {
        case .fetchUsers, .registerUser:
            return "/users"
        case .fetchPositions:
            return "/positions"
        case .fetchToken:
            return "/token"
        case .getUserBy(let id):
            return "/users/\(id)"
        }
    }
    
    /// The full URL string, including any query parameters if needed.
    ///
    /// This is where query parameters for endpoints like `fetchUsers` are appended.
    var urlString: String {
        switch self {
        case .fetchUsers(let page, let count):
            return "\(baseURL)\(path)?page=\(page)&count=\(count)"
        case .registerUser, .fetchPositions, .fetchToken, .getUserBy:
            return "\(baseURL)\(path)"
        }
    }
    
    /// The full URL constructed from the base URL and path.
    ///
    /// This returns an optional `URL` that can be used to make network requests.
    var url: URL? {
        return URL(string: urlString)
    }
}
