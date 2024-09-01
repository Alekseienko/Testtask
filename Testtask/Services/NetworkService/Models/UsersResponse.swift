//
//  UsersResponse.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import Foundation

struct UsersResponse: Decodable {
    let success: Bool
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let page: Int
    let links: Links
    let users: [User]

    private enum CodingKeys: String, CodingKey {
        case success, count, page, users
        case totalPages = "total_pages"
        case totalUsers = "total_users"
        case links
    }
}
