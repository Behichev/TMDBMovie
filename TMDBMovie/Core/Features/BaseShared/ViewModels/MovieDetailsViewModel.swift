//
//  MovieDetailsViewModel.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 17.05.2025.
//

import SwiftUI
import Combine

final class MovieDetailsViewModel: ObservableObject {
    
    @Published var movie: Movie?
    @Published var moviesStorage: MoviesStorage
    
    private let repository: TMDBRepositoryProtocol
    private let movieID: Int
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: TMDBRepositoryProtocol, moviesStorage: MoviesStorage, movieID: Int) {
        self.repository = repository
        self.movieID = movieID
        self.moviesStorage = moviesStorage
        
        moviesStorage.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func getMovieDetails() {
        let publisher = repository.getMovieDetails(movieID)
        let isInFavorite = checkInFavorites()
        if let index = moviesStorage.moviesCache.firstIndex(where: { $0.id == movieID }) {
            movie = moviesStorage.moviesCache[index]
            movie?.isInFavorite = isInFavorite
            
            publisher
                .sink { _ in } receiveValue: { [weak self] movie in
                    var responseMovie = movie
                    responseMovie.isInFavorite = isInFavorite
                    
                    if self?.movie != responseMovie {
                        self?.movie = responseMovie
                    }
                    
                    self?.moviesStorage.moviesCache[index] = movie
                }
                .store(in: &cancellables)
        } else {
            publisher
                .sink { _ in } receiveValue: { [weak self] movie in
                    self?.movie = movie
                    self?.movie?.isInFavorite = isInFavorite
                    
                    self?.moviesStorage.moviesCache.append(movie)
                }
                .store(in: &cancellables)
        }
    }
    
    func toggleFavorite() {
        let initialFavoritesState = movie?.isInFavorite ?? false
        moviesStorage.favoritesToggle(convertMovieToMediaItem())
        movie?.isInFavorite?.toggle()
        repository.favoritesToggle(id: movieID, type: "movie", isInFavorites: initialFavoritesState)
            .sink { [weak self] completion in
                if case .failure(_) = completion {
                    let media = self?.convertMovieToMediaItem()
                    
                    if let media {
                        self?.moviesStorage.favoritesToggle(media)
                    }
                    
                    self?.movie?.isInFavorite = initialFavoritesState
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func setImage(_ path: String) async throws -> UIImage? {
        do {
            let data = try await repository.loadImage(path, size: 500)
            let image = UIImage(data: data)
            return image
        } catch {
            throw error
        }
    }
    
    private func checkInFavorites() -> Bool {
        (moviesStorage.favoritesMovies.firstIndex(where: {$0.id == movieID }) != nil)
    }
    
    private func convertMovieToMediaItem() -> Media {
        Media(id: movieID, name: nil, originalName: nil, title: nil, originalTitle: nil, overview: "", posterPath: movie?.posterPath, backdropPath: movie?.backdropPath, adult: false, originalLanguage: "", genreIds: [], popularity: 0, voteAverage: 0, voteCount: 0, originCountry: nil, firstAirDate: nil, releaseDate: nil, video: nil, isInFavorites: movie?.isInFavorite)
    }
}
