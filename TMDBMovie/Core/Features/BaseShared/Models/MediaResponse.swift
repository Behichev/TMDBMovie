//
//  MediaResponse.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 15.04.2025.
//

import Foundation

struct MediaResponse: Decodable {
    let page: Int
    let results: [Media]
    let totalPages: Int
    let totalResults: Int
}

struct Media: Codable, Identifiable, Equatable {
    let id: Int
    var mediaType: MediaType?
    let name: String?
    let originalName: String?
    let title: String?
    let originalTitle: String?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let adult: Bool
    let originalLanguage: String
    let genreIds: [Int]
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let originCountry: [String]?
    let firstAirDate: String?
    let releaseDate: String?
    let video: Bool?
    var isInFavorites: Bool? = false
    
    enum MediaType: String, Codable {
        case movie
        case tv
    }
}
