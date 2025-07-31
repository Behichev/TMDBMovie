//
//  TMDBRepository.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 14.05.2025.
//

import Foundation
import Combine
//TODO: - Add all combine methods
final class TMDBRepository: TMDBRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let imageService: ImageLoaderService
    private let keychainService: SecureStorable
    private let combineNetworkService: CombineNetworkServiceProtocol
    private let userID: String
    
    private var errorManager: ErrorManager
    private var authEndpoint: AuthEndpoint?
    private var token: TMDBToken?
    
    init(networkService: NetworkServiceProtocol,
         imageService: ImageLoaderService,
         keychainService: SecureStorable,
         errorManager: ErrorManager, cNetworkService: CombineNetworkServiceProtocol) {
        self.networkService = networkService
        self.imageService = imageService
        self.keychainService = keychainService
        self.errorManager = errorManager
        self.combineNetworkService = cNetworkService
        
        userID = String(keychainService.get(forKey: Constants.KeychainKeys.userID.rawValue, as: Int.self) ?? 0)
    }
    
    func setErrorManager(_ errorManager: ErrorManager) {
        self.errorManager = errorManager
    }
    //MARK: - Authorization
    //TODO: - Replace auht with Combine
    func requestToken() async throws {
        do {
            authEndpoint = .newToken(apiKey: Constants.APIKeys.token)
            guard let authEndpoint else { return }
            token = try await networkService.performRequest(from: authEndpoint)
        } catch {
            throw error
        }
    }
    
    func userAuthorization(with credentials: Credentials) async throws {
        authEndpoint = .validateWithLogin(apiKey: Constants.APIKeys.token, requestToken: token?.requestToken ?? "", credentials: credentials)
        guard let authEndpoint else { return }
        do {
            try await networkService.performPostRequest(from: authEndpoint)
        } catch let authError as NetworkError {
            await errorManager.showError(authError.localizedDescription)
            throw NetworkError.invalidCredentials
        } catch {
            await errorManager.showError("\(NetworkError.invalidCredentials.localizedDescription)")
            throw error
        }
    }
    
    func createSession() async throws {
        authEndpoint = .newSession(apiKey: Constants.APIKeys.token, sessionID: token?.requestToken ?? "")
        guard let authEndpoint else { return }
        do {
            let token: SessionModel = try await networkService.performRequest(from: authEndpoint)
            keychainService.save(token.sessionId, forKey: Constants.KeychainKeys.session.rawValue)
        } catch {
            await errorManager.showError("\(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteSession(_ apiKey: String, _ sessionID: String) async throws {
        authEndpoint = .deleteUser(apiKey: apiKey, sessionID: sessionID)
        guard let authEndpoint else { return }
        do {
            try await networkService.performPostRequest(from: authEndpoint)
        } catch {
            await errorManager.showError("\(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchUser(with apiKey: String) async throws -> User {
        let sessionID = keychainService.get(forKey: Constants.KeychainKeys.session.rawValue, as: String.self) ?? ""
        authEndpoint = .validation(apiKey: apiKey, sessionID: sessionID)
        guard let authEndpoint else { throw URLError(.badURL) }
        do {
            let user: User = try await networkService.performRequest(from: authEndpoint)
            keychainService.save(user.id, forKey: Constants.KeychainKeys.userID.rawValue)
            return user
        } catch {
            throw error
        }
    }
    //MARK: - Movies/Shows
  
    func fetchTrendingMovies() -> AnyPublisher <[Media], Error> {
        let endpoint = MediaEndpoint.trending(mediaItem: .movie, timeWindow: TimeWindow.day.rawValue)
        return combineNetworkService.performRequest(from: endpoint, MediaResponse.self)
            .map(\.results)
            .catch { [weak self] error -> AnyPublisher<[Media], Error> in
                
                    self?.errorManager.showError("Loading media error")
                
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchFavoritesMovies() -> AnyPublisher <[Media], Error> {
        let endpoint = MediaEndpoint.favoriteMovies(accountId: userID)
        return combineNetworkService.performRequest(from: endpoint, MediaResponse.self)
            .map(\.results)
            .map { favoriteMedia in
                favoriteMedia.map { media in
                    var updatedMedia = media
                    updatedMedia.isInFavorites = true
                    return updatedMedia
                }
            }
            .catch { [weak self] error -> AnyPublisher<[Media], Error> in
                
                    self?.errorManager.showError("Loading media error")
                
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchMoviesList(page: Int) -> AnyPublisher<[Media], Error> {
        let endpoint = MediaEndpoint.moviesList(page: "\(page)")
        return combineNetworkService.performRequest(from: endpoint, MediaResponse.self)
            .map(\.results)
            .catch { [weak self] error -> AnyPublisher<[Media], Error> in
                
                    self?.errorManager.showError("Loading media error")
                
                return Fail(error: error).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getMovieDetails(_ movieID: Int) -> AnyPublisher<Movie, Error> {
        let endpoint = MediaEndpoint.movieDetails(movieID: "\(movieID)")
        
        return combineNetworkService.performRequest(from: endpoint, Movie.self)
            .catch { [weak self] error -> AnyPublisher<Movie, Error> in
                self?.errorManager.showError("Can't load movie")
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Favorites/WathList
    
    func addToFavorites(id: Int, type: String) -> AnyPublisher<TMDBResponse, any Error> {
        let endpoint = MediaEndpoint.addToFavorites(accountId: userID, itemID: id, itemType: type)
        
        return combineNetworkService.performRequest(from: endpoint, TMDBResponse.self)
            .catch { [weak self] error -> AnyPublisher<TMDBResponse, Error> in
                self?.errorManager.showError("Something went wrong")
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func removeFromFavorites(id: Int, type: String) -> AnyPublisher<TMDBResponse, any Error> {
        let endpoint = MediaEndpoint.removeFromFavorites(accountId: userID, itemID: id, mediaType: type)
        
        return combineNetworkService.performRequest(from: endpoint, TMDBResponse.self)
            .catch { [weak self] error -> AnyPublisher<TMDBResponse, Error> in
                self?.errorManager.showError("Something went wrong")
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func favoritesToggle(id: Int, type: String, isInFavorites: Bool) -> AnyPublisher<TMDBResponse, any Error> {
        if isInFavorites {
            return removeFromFavorites(id: id, type: type)
        } else {
            return addToFavorites(id: id, type: type)
        }
    }
    
    //MARK: - Images
    func loadImage(_ path: String, size: Int = 200) async throws -> Data {
        do {
            let url = try imageService.prepareImagePath(from: path, size: size)
            let data = try await imageService.loadImageData(from: url)
            return data
        } catch {
            
            throw error
        }
    }
}
