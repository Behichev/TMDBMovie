//
//  MockHelper.swift
//  TMDBMovie
//
//  Created by Ivan Behichev on 13.06.2025.
//

import UIKit
import Combine

struct MockHelper {
    static let mockMediaItem: Media = Media(id: 238, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
    
    static let moviesList: [Media] = [
        Media(id: 238, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
        ,Media(id: 237, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
        , Media(id: 236, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
    ]
    
    static func setImage(_ poster: String) async -> UIImage? {
        return UIImage(named: "mockPoster")
    }
}

final class MockRepository: TMDBRepositoryProtocol {
    func fetchMoviesList(page: Int) -> AnyPublisher<[Media], any Error> {
        let mockMovies = [
            Media(id: 236, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
        ]
        
        return Just(mockMovies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func getMovieDetails(_ movieID: Int) -> AnyPublisher<Movie, any Error> {
        let movie = Movie(adult: false, backdropPath: "/lSbblLngbeZIn6G4WXDcyQ6SLhw.jpg", belongsToCollection: nil, budget: 200000000, genres: [TMDBMovie.Genre(id: 28, name: "Action"), TMDBMovie.Genre(id: 18, name: "Drama")], homepage: "https://www.f1themovie.com", id: 911430, imdbID: nil, originCountry: ["US"], originalLanguage: "en", originalTitle: "F1 The Movie", overview: "Racing legend Sonny Hayes is coaxed out of retirement to lead a struggling Formula 1 team—and mentor a young hotshot driver—while chasing one more chance at glory.", popularity: 195.915, posterPath: "/vqBmyAj0Xm9LnS1xe1MSlMAJyHq.jpg", productionCompanies: [TMDBMovie.ProductionCompany(id: 81, logoPath: Optional("/8wOfUhA7vwU2gbPjQy7Vv3EiF0o.png"), name: "Plan B Entertainment", originCountry: "US"), TMDBMovie.ProductionCompany(id: 130, logoPath: Optional("/c9dVHPOL3cqCr2593Ahk0nEKTEM.png"), name: "Jerry Bruckheimer Films", originCountry: "US"), TMDBMovie.ProductionCompany(id: 199632, logoPath: nil, name: "Dawn Apollo Films", originCountry: "US"), TMDBMovie.ProductionCompany(id: 194232, logoPath: Optional("/oE7H93u8sy5vvW5EH3fpCp68vvB.png"), name: "Apple Studios", originCountry: "US"), TMDBMovie.ProductionCompany(id: 19647, logoPath: nil, name: "Monolith Pictures", originCountry: "US")], productionCountries: [TMDBMovie.ProductionCountry(iso3166_1: nil, name: "United States of America")], releaseDate: "2025-06-23", revenue: 64500000, runtime: 156, spokenLanguages: [TMDBMovie.SpokenLanguage(englishName: "Danish", iso639_1: nil, name: "Dansk"), TMDBMovie.SpokenLanguage(englishName: "Spanish", iso639_1: nil, name: "Español"), TMDBMovie.SpokenLanguage(englishName: "English", iso639_1: nil, name: "English")], status: "Released", tagline: Optional(""), title: "F1 The Movie", video: false, voteAverage: 7.7, voteCount: 151)
        
        return Just(movie)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func addToFavorites(id: Int, type: String) -> AnyPublisher<TMDBResponse, any Error> {
        let response = TMDBResponse(success: true, statusCode: 1, statusMessage: "")
        
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func removeFromFavorites(id: Int, type: String) -> AnyPublisher<TMDBResponse, any Error> {
        let response = TMDBResponse(success: true, statusCode: 1, statusMessage: "")
        
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func favoritesToggle(id: Int, type: String, isInFavorites: Bool) -> AnyPublisher<TMDBResponse, any Error> {
        let response = TMDBResponse(success: true, statusCode: 1, statusMessage: "")
        
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchFavoritesMovies() -> AnyPublisher<[Media], any Error> {
        let mockMovies = [
            Media(id: 236, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
        ]
        
        return Just(mockMovies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchMoviesList(page: Int) -> AnyPublisher<[Media], any Error> {
        let mockMovies = [
            Media(id: 236, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
        ]
        
        return Just(mockMovies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchTrendingMovies() -> AnyPublisher<[Media], any Error> {
        let mockMovies = [
            Media(id: 236, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
        ]
        
        return Just(mockMovies)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    
    private var errorManager: ErrorManager?
    
    init(errorManager: ErrorManager? = nil) {
        self.errorManager = errorManager
    }
    
    var shouldThrowError: Bool = false
    
    func requestToken() async throws {
        if shouldThrowError {
            await errorManager?.showError("Show error!")
        }
    }
    
    func userAuthorization(with credentials: Credentials) async throws { }
    
    func createSession() async throws { }
    
    func deleteSession(_ apiKey: String, _ sessionID: String) async throws { }
    
    func fetchUser(with apiKey: String) async throws -> User {
        return User(avatar: Avatar(gravatar: Gravatar(hash: ""), tmdb: try Tmdb(from: "sd" as! Decoder)), id: 0, iso6391: "", iso31661: "", name: "", includeAdult: false, username: "")
    }
    
    func fetchTrendingMedia() async throws -> [Media] {
        return MockHelper.moviesList
    }
    
    func fetchFavoritesMovies() async throws -> [Media] {
        return MockHelper.moviesList
    }
    
    func favoritesToggle(_ item: Media, mediaType: MediaType) async throws {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
    }
    
    func addMovieToFavorite(_ item: Media) async throws { }
    
    func addMovieToFavorite(_ movieID: Int) async throws { }
    
    func removeMovieFromFavorites(_ movieID: Int) async throws { }
    
    func deleteMediaFromFavorites(_ item: Media) async throws { }
    
    func loadImage(_ path: String, size: Int) async throws -> Data {
        return Data()
    }
    
    func fetchMovieList(page: Int) async throws -> [Media] {
        return MockHelper.moviesList
    }
    
    func fetchMovie(_ id: Int) async throws -> Movie {
        Movie(adult: false, backdropPath: "/lSbblLngbeZIn6G4WXDcyQ6SLhw.jpg", belongsToCollection: nil, budget: 200000000, genres: [TMDBMovie.Genre(id: 28, name: "Action"), TMDBMovie.Genre(id: 18, name: "Drama")], homepage: "https://www.f1themovie.com", id: 911430, imdbID: nil, originCountry: ["US"], originalLanguage: "en", originalTitle: "F1 The Movie", overview: "Racing legend Sonny Hayes is coaxed out of retirement to lead a struggling Formula 1 team—and mentor a young hotshot driver—while chasing one more chance at glory.", popularity: 195.915, posterPath: "/vqBmyAj0Xm9LnS1xe1MSlMAJyHq.jpg", productionCompanies: [TMDBMovie.ProductionCompany(id: 81, logoPath: Optional("/8wOfUhA7vwU2gbPjQy7Vv3EiF0o.png"), name: "Plan B Entertainment", originCountry: "US"), TMDBMovie.ProductionCompany(id: 130, logoPath: Optional("/c9dVHPOL3cqCr2593Ahk0nEKTEM.png"), name: "Jerry Bruckheimer Films", originCountry: "US"), TMDBMovie.ProductionCompany(id: 199632, logoPath: nil, name: "Dawn Apollo Films", originCountry: "US"), TMDBMovie.ProductionCompany(id: 194232, logoPath: Optional("/oE7H93u8sy5vvW5EH3fpCp68vvB.png"), name: "Apple Studios", originCountry: "US"), TMDBMovie.ProductionCompany(id: 19647, logoPath: nil, name: "Monolith Pictures", originCountry: "US")], productionCountries: [TMDBMovie.ProductionCountry(iso3166_1: nil, name: "United States of America")], releaseDate: "2025-06-23", revenue: 64500000, runtime: 156, spokenLanguages: [TMDBMovie.SpokenLanguage(englishName: "Danish", iso639_1: nil, name: "Dansk"), TMDBMovie.SpokenLanguage(englishName: "Spanish", iso639_1: nil, name: "Español"), TMDBMovie.SpokenLanguage(englishName: "English", iso639_1: nil, name: "English")], status: "Released", tagline: Optional(""), title: "F1 The Movie", video: false, voteAverage: 7.7, voteCount: 151)
    }
}

final class MockMovieStorage: MoviesStorageProtocol {
    var trendingMovies: [Media] = [
        Media(id: 238, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
        ,Media(id: 237, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
        , Media(id: 236, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
    ]
    
    var favoritesMovies: [Media] = []
    
    var moviesList: [Media] = [
        Media(id: 238, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
        ,Media(id: 237, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
        , Media(id: 236, name: nil, originalName: nil, title: "The Godfather", originalTitle: "The Godfather", overview: "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.", posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg", backdropPath: "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg", adult: false, originalLanguage: "en", genreIds: [18,80], popularity: 55.5205, voteAverage: 8.686, voteCount: 21522, originCountry: nil, firstAirDate: nil, releaseDate: "1972-03-14", video: false)
    ]
    
    var moviesCache: [Movie] = []
    
    func favoritesToggle(_ item: Media) {
        if item.isInFavorites ?? false {
            removeFromFavorites(item)
        } else {
            addToFavorites(item)
        }
    }
    
    func addToFavorites(_ item: Media) {
        var favoriteItem = item
        favoriteItem.isInFavorites = true
        favoritesMovies.append(favoriteItem)
    }
    
    func removeFromFavorites(_ item: Media) {
        if let index = favoritesMovies.firstIndex(where: { $0.id == item.id }) {
            favoritesMovies.remove(at: index)
        }
    }
}
