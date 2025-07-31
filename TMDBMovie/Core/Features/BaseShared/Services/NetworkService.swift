//
//  NetworkService.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 10.04.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func performRequest<T: Decodable>(from endpoint: Endpoint) async throws -> T
    func performPostRequest(from endpoint: Endpoint) async throws
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: DataDecoder
    
    init(session: URLSession = .shared, decoder: DataDecoder = JSONDataDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    private func createRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard let basePath = URL(string: "https://api.themoviedb.org") else { throw URLError(.badURL) }
        
        var components = URLComponents()
        components.scheme = basePath.scheme
        components.host = basePath.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.timeoutInterval = 60
        request.allHTTPHeaderFields = endpoint.headers
        
        let body = endpoint.body
        
        if let body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            print(body)
        }
        
        return request
    }
    
    func performRequest<T>(from endpoint: Endpoint) async throws -> T where T : Decodable {
        do {
            let request = try createRequest(from: endpoint)
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            print(error.localizedDescription)
            throw error
        }
    }
    
    func performPostRequest(from endpoint: Endpoint) async throws {
        do {
            let request = try createRequest(from: endpoint)
            let (_, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                return
            case 401:
                throw NetworkError.invalidCredentials
            default:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            }
            
        } catch {
            throw error
        }
    }
}
