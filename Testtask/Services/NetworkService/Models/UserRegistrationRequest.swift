//
//  UserRegistrationRequest.swift
//  Testtask
//
//  Created by Alekseienko on 31.08.2024.
//

import Foundation

struct UserRegistrationRequest: Encodable {
    let name: String
    let email: String
    let phone: String
    let position_id: Int
    let photo: Data
}
