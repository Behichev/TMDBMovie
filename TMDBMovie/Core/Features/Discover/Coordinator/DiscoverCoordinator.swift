//
//  DiscoverCoordinator.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

enum DiscoverCoordinatorPages: Hashable {
    case details(id: Int)
}

final class DiscoverCoordinator: Coordinator, ObservableObject {
 
    @Published var path = NavigationPath()
    
    var moviesStorage: MoviesStorage
    let repository: TMDBRepositoryProtocol
    private var _viewModel: DiscoverMovieViewModel?
     var viewModel: DiscoverMovieViewModel {
         if _viewModel == nil {
             _viewModel = DiscoverMovieViewModel(repository: repository, movieStorage: moviesStorage)
         }
         return _viewModel!
     }
     
    
    init(repository: TMDBRepositoryProtocol, moviesStorage: MoviesStorage) {
        self.repository = repository
        self.moviesStorage = moviesStorage
//        self.viewModel = DiscoverMovieViewModel(repository: repository, movieStorage: moviesStorage)
        print("✅ Discover Coordinator init")
    }
    
    deinit {
        print("❌ Discover Coordinator DEINIT")
    }
    
    @ViewBuilder
    func rootView() -> some View  {
        DiscoverMovieView(viewModel: self.viewModel, onMediaTapped: { id in
            self.push(.details(id: id))
        })
    }
    
    func push(_ page: DiscoverCoordinatorPages) {
        path.append(page)
    }
    
    func pop(_ last: Int = 1) {
        path.removeLast(last)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func closeAllChild() {
        path = NavigationPath()
    }
    
    @ViewBuilder
    func build(_ page: DiscoverCoordinatorPages) -> some View {
        switch page {
        case .details(let id):
            MovieDetailsView(repository: repository, movieStorage: moviesStorage, movieID: id)
        }
    }
}
