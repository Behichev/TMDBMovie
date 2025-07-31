//
//  TMDBResponse.swift
//  TMDBMovie
//
//  Created by Ivan Behichev on 29.07.2025.
//

import Foundation

struct TMDBResponse: Codable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
}
