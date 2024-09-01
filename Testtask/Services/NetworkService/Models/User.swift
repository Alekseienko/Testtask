//
//  User.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionId: Int
    let registrationTimestamp: Int?
    let photo: String

    private enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position
        case positionId = "position_id"
        case registrationTimestamp = "registration_timestamp"
        case photo
    }
}
