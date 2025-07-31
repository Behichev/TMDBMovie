//
//  TrendingMediaViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 15.04.2025.
//

import SwiftUI
import Combine

final class TrendingMediaViewModel: ObservableObject {
    
    @Published var viewState: TrendingMediaViewState = .success
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
    
    enum TrendingMediaViewState {
        case loading
        case success
    }
    
    func combineTrendingMedia() {
        isLoaded = true
        viewState = .loading
        let publisher = Publishers.Zip(repository.fetchTrendingMovies(), repository.fetchFavoritesMovies())
        
        if mediaStorage.trendingMovies.isEmpty {
            publisher
                .sink { [weak self] completion in
                    switch completion {
                    case .failure(_):
                        self?.isLoaded = false
                    case .finished:
                        self?.viewState = .success
                    }
                } receiveValue: { [weak self] (trending, favorites) in
                    self?.mediaStorage.trendingMovies = trending
                    self?.mediaStorage.favoritesMovies = favorites
                    
                    for item in self?.mediaStorage.favoritesMovies ?? [] {
                        self?.updateFavorite(item)
                    }
                    self?.viewState = .success
                }
                .store(in: &cancellables)
        } else {
            publisher
                .sink { [weak self] completion in
                    self?.isLoaded = false
                    self?.viewState = .success
                } receiveValue: { [weak self] (trending, favorites) in
                    
                    var newTrendingValue = trending
                    let newFavoritesValue = favorites
                    
                    for item in newFavoritesValue {
                        if let index = newTrendingValue.firstIndex(where: { $0.id == item.id }) {
                            newTrendingValue[index].isInFavorites = item.isInFavorites
                        }
                    }
                    
                    if self?.mediaStorage.trendingMovies != newTrendingValue {
                        self?.mediaStorage.trendingMovies = trending
                        self?.mediaStorage.favoritesMovies = favorites
                        
                        for item in self?.mediaStorage.favoritesMovies ?? [] {
                            self?.updateFavorite(item)
                        }
                    }
                    self?.viewState = .success
                }
                .store(in: &cancellables)
        }
    }
    
    func favoritesToggle(_ item: Media) {
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
    
    private func updateFavorite(_ item: Media) {
        if let index = mediaStorage.trendingMovies.firstIndex(where: { $0.id == item.id }) {
            mediaStorage.trendingMovies[index].isInFavorites = item.isInFavorites
        }
    }
}
