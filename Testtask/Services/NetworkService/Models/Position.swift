//
//  Position.swift
//  Testtask
//
//  Created by Alekseienko on 31.08.2024.
//

import Foundation

struct Position: Decodable {
    let id: Int
    let name: String
}

struct PositionsResponse: Decodable {
    let success: Bool
    let positions: [Position]
}
