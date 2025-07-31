//
//  TMDBRepositoryProtocol.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 14.05.2025.
//

import Foundation
import Combine

protocol TMDBRepositoryProtocol {
    //async/await
    func requestToken() async throws
    func userAuthorization(with credentials: Credentials) async throws
    func createSession() async throws
    func deleteSession(_ apiKey: String, _ sessionID: String) async throws
    func fetchUser(with apiKey: String) async throws -> User
    func loadImage(_ path: String, size: Int) async throws -> Data
    //Combine
    func fetchTrendingMovies() -> AnyPublisher <[Media], Error>
    func fetchFavoritesMovies() -> AnyPublisher <[Media], Error>
    func fetchMoviesList(page: Int) -> AnyPublisher<[Media], Error>
    func addToFavorites(id: Int, type: String) -> AnyPublisher<TMDBResponse, Error>
    func removeFromFavorites(id: Int, type: String) -> AnyPublisher<TMDBResponse, Error>
    func favoritesToggle(id: Int, type: String, isInFavorites: Bool) -> AnyPublisher<TMDBResponse, Error>
    func getMovieDetails(_ movieID: Int) -> AnyPublisher<Movie, Error>
}


