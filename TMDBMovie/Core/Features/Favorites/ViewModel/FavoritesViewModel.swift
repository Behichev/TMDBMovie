//
//  FavoritesViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 03.05.2025.
//

import SwiftUI
import Combine

final class FavoritesViewModel: ObservableObject {
    
    @Published var viewState: TrendingViewState = .success
    @Published var mediaStorage: MoviesStorage
    
    var isLoaded = false
    let repository: TMDBRepositoryProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: TMDBRepositoryProtocol, mediaStorage: MoviesStorage) {
        self.repository = repository
        self.mediaStorage = mediaStorage
        
        mediaStorage.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
        }
            .store(in: &cancellables)
    }
    
    enum TrendingViewState {
        case loading
        case success
    }
    
    func fetchFavorites() {
        isLoaded = true
        let publisher = repository.fetchFavoritesMovies()
        
        if mediaStorage.favoritesMovies.isEmpty {
                publisher
                .sink { [weak self] completion in
                    self?.isLoaded = false
                } receiveValue: { [weak self] favorites in
                    self?.mediaStorage.favoritesMovies = favorites
                }
                .store(in: &cancellables)
        } else {
            publisher
            .sink { [weak self] completion in
                self?.isLoaded = false
            } receiveValue: { [weak self] favorites in
                if favorites != self?.mediaStorage.favoritesMovies {
                    self?.mediaStorage.favoritesMovies = favorites
                }
            }
            .store(in: &cancellables)
        }
    }
    
    func toggleFavorites(_ item: Media) {
        mediaStorage.favoritesToggle(item)
        repository.favoritesToggle(id: item.id, type: item.mediaType?.rawValue ?? "movie", isInFavorites: item.isInFavorites ?? false)
            .sink { [weak self] completion in
                if case .failure(_) = completion {
                    self?.mediaStorage.favoritesToggle(item)
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func setImage(_ path: String) async throws -> UIImage? {
        do {
            let data = try await repository.loadImage(path, size: 200)
            let image = UIImage(data: data)
            return image
        } catch {
            throw error
        }
    }
}
