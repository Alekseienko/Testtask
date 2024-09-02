//
//  NetworkService.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import Foundation

/// A protocol defining a network service for interacting with various API endpoints.
protocol NetworkService {
    
    /// Fetches an authentication token.
    ///
    /// This method performs an asynchronous request to retrieve an authentication token required for accessing secured endpoints.
    ///
    /// - Returns: A `TokenResponse` object containing the token and associated data.
    /// - Throws: An error if the token cannot be fetched.
    func fetchToken() async throws -> TokenResponse
    
    /// Fetches a list of users.
    ///
    /// This method performs an asynchronous request to retrieve a paginated list of users.
    ///
    /// - Parameters:
    ///   - page: The page number to fetch.
    ///   - count: The number of users to retrieve per page.
    /// - Returns: A `UsersResponse` object containing the list of users and pagination information.
    /// - Throws: An error if the users cannot be fetched.
    func fetchUsers(page: Int, count: Int) async throws -> UsersResponse
    
    /// Registers a new user.
    ///
    /// This method performs an asynchronous request to register a new user with the provided registration details.
    ///
    /// - Parameter request: A `UserRegistrationRequest` object containing the user's registration details.
    /// - Returns: A `UserRegistrationResponse` object containing the response data after registration.
    /// - Throws: An error if the user cannot be registered.
    func registerUser(request: UserRegistrationRequest) async throws -> UserRegistrationResponse
    
    /// Fetches a list of available positions.
    ///
    /// This method performs an asynchronous request to retrieve a list of job positions or roles that users can be associated with.
    ///
    /// - Returns: A `PositionsResponse` object containing the list of positions.
    /// - Throws: An error if the positions cannot be fetched.
    func fetchPositions() async throws -> PositionsResponse
    
    /// Retrieves a user by their ID.
    ///
    /// This method performs an asynchronous request to fetch details of a specific user by their unique identifier.
    ///
    /// - Parameter id: The unique identifier of the user to fetch. This parameter is optional.
    /// - Returns: A `UserResponse` object containing the user's details.
    /// - Throws: An error if the user cannot be fetched.
    func getUserBy(id: Int) async throws -> UserResponse
}
