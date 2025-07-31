//
//  MoviesStorage.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 14.05.2025.
//

import Foundation

protocol MoviesStorageProtocol {
    
    var trendingMovies: [Media] { get set }
    var favoritesMovies: [Media] { get set }
    var moviesList: [Media] { get set }
    var moviesCache: [Movie] {get set } 
    func favoritesToggle(_ item: Media)
    func addToFavorites(_ item: Media)
    func removeFromFavorites (_ item: Media)
}
