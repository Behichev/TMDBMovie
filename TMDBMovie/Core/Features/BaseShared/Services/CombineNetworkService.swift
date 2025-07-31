//
//  CombineNetworkService.swift
//  TMDBMovie
//
//  Created by Ivan Behichev on 25.07.2025.
//

import Foundation
import Combine

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error, LocalizedError {
    case invalidCredentials
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid username and/or password"
        case .serverError(let code):
            return "Server return error: \(code)"
        }
    }
}

protocol Endpoint {
    var path: String { get }
    var headers: [String : String]? {get}
    var body: Parameters? { get }
    var httpMethod: HTTPMethods { get }
    var queryItems: [URLQueryItem]? { get }
}

typealias Parameters = [String: Any]

protocol CombineNetworkServiceProtocol {
    func performRequest<T: Decodable>(from endpoint: Endpoint, _ type: T.Type) -> AnyPublisher<T, Error>
}

final class CombineNetworkService: CombineNetworkServiceProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    private func createRequest(from endpoint: Endpoint) -> Result<URLRequest, Error> {
        guard let basePath = URL(string: "https://api.themoviedb.org") else { return .failure(URLError(.badURL)) }
        
        var components = URLComponents()
        components.scheme = basePath.scheme
        components.host = basePath.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            return .failure(URLError(.badURL))
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
        
        return .success(request)
    }
    
    func performRequest<T>(from endpoint: any Endpoint, _ type: T.Type) -> AnyPublisher<T, any Error> where T : Decodable {
        let request = createRequest(from: endpoint)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        switch request {
        case .success(let success):
            return session.dataTaskPublisher(for: success)
                .tryMap { data, response in
                
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw URLError(.badServerResponse)
                    }
                    
                    guard 200...299 ~= httpResponse.statusCode else {
                        throw URLError(.unknown)
                    }
                    
                    return data
                }
                .decode(type: type, decoder: decoder)
                .mapError { error in
                    if error is DecodingError {
                        return URLError(.cannotDecodeContentData)
                    }
                    return error
                }
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .failure(_):
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
    }
}
