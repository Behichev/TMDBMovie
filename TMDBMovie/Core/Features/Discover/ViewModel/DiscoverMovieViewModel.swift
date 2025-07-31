//
//  DiscoverMovieViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 16.05.2025.
//

import SwiftUI
import Combine

final class DiscoverMovieViewModel: ObservableObject {
    
    @Published var movieStorage: MoviesStorage
    @Published var viewState: DiscoverViewState = .success
    
    var isHasLoaded = false
    var isNextPageLoading = false
    
    private var currentPage = 1
    
    let repository: TMDBRepositoryProtocol
    let mediaType: MediaType = .movie
    
    private var cancellables = Set<AnyCancellable>()
    
    //debug
    private let id = UUID()
    
    init(repository: TMDBRepositoryProtocol, movieStorage: MoviesStorage) {
        self.repository = repository
        self.movieStorage = movieStorage
        
        movieStorage.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        .store(in: &cancellables)
        
        print("✅ DiscoverMovieViewModel init: \(id)")
    }
    
    deinit {
        print("❌ DiscoverMovieViewModel deinit: \(id)")
    }
    
    enum DiscoverViewState {
        case loading
        case success
    }
    
    func loadMovies() {
        isHasLoaded = true
        repository.fetchMoviesList(page: currentPage)
            .sink { [weak self] _ in
                self?.isHasLoaded = false
            } receiveValue: { [weak self] movies in
                self?.movieStorage.moviesList = movies
                self?.syncWithFavorites()
            }
            .store(in: &cancellables)
    }
    
    func loadNextPage() {
        guard !isNextPageLoading else { return }
        isNextPageLoading = true
        currentPage += 1
        
        repository.fetchMoviesList(page: currentPage)
            .sink { [weak self ] completion in
                self?.isNextPageLoading = false
            } receiveValue: { [weak self] movies in
                
                let existingIDs = Set(self!.movieStorage.moviesList.map { $0.id })
                let uniqueMovies = movies.filter { !existingIDs.contains($0.id) }
                
                self?.movieStorage.moviesList += uniqueMovies
                self?.syncWithFavorites()
            }
            .store(in: &cancellables)
    }
    
    func favoritesToggle(_ item: Media)  {
        let initialState = item.isInFavorites ?? false
        movieStorage.favoritesToggle(item)
        repository.favoritesToggle(id: item.id, type: item.mediaType?.rawValue ?? "movie", isInFavorites: initialState)
            .sink { [weak self] completion in
                self?.movieStorage.favoritesToggle(item)
                self?.updateFavorite(item)
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func hasReachedEnd(of item: Media) -> Bool {
        movieStorage.moviesList.last?.id == item.id
    }
    
    private func updateFavorite(_ item: Media) {
        if let index = movieStorage.moviesList.firstIndex(where: { $0.id == item.id }) {
            movieStorage.moviesList[index].isInFavorites = item.isInFavorites
        }
    }
    
    private func syncWithFavorites() {
        for item in movieStorage.favoritesMovies {
            updateFavorite(item)
        }
    }
}
