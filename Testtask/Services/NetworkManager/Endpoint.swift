//
//  Endpoint.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import Foundation

// The base URL for the API.
//"https://frontend-test-assignment-api.abz.agency/api/v1"

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
    
    /// The path component of the URL for each endpoint.
    private var path: String {
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
    
    /// Query parameters for each endpoint.
    private var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchUsers(let page, let count):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "count", value: "\(count)")
            ]
        case .registerUser, .fetchPositions, .fetchToken, .getUserBy:
            return nil
        }
    }
    
    /// The full URL constructed using `URLComponents`.
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "frontend-test-assignment-api.abz.agency"
        components.path = "/api/v1" + path
        components.queryItems = queryItems
        
        return components.url
    }
}
