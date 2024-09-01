//
//  UserRegistrationResponse.swift
//  Testtask
//
//  Created by Alekseienko on 01.09.2024.
//

import Foundation

struct UserRegistrationResponse: Decodable {
    let success: Bool
    let message: String
    let user_id: Int?
}
