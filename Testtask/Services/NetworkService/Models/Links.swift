//
//  Links.swift
//  Testtask
//
//  Created by Alekseienko on 29.08.2024.
//

import Foundation

struct Links: Decodable {
    let nextUrl: String?
    let prevUrl: String?

    private enum CodingKeys: String, CodingKey {
        case nextUrl = "next_url"
        case prevUrl = "prev_url"
    }
}
