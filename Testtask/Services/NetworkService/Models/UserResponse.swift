//
//  UserResponse.swift
//  Testtask
//
//  Created by Alekseienko on 01.09.2024.
//

import Foundation

struct UserResponse: Decodable {
    let success: Bool
    let user: User
}
