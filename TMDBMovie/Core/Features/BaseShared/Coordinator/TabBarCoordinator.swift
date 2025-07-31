//
//  TabBarCoordinator.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

enum TabBarItem {
    case trending
    case discovery
    case favorite
    case userProfile
}

final class TabBarCoordinator: ObservableObject {
    
    @Published var selectedTab: TabBarItem = .trending
    
     var trendingCoordinator: TrendingCoordinator?
     var discoverCoordinator: DiscoverCoordinator?
     var favoritesCoordinator: FavoritesCoordinator?
    
    let repository: TMDBRepositoryProtocol
    var mediaStorage: MoviesStorage
    
    init(repository: TMDBRepositoryProtocol, mediaStorage: MoviesStorage) {
        self.repository = repository
        self.mediaStorage = mediaStorage
        
        setupCoordinators()
        
        print("✅ Tab Bar Coordinator init")
    }
    
    deinit {
        print("❌ Tab Bar Coordinator DEINIT")
    }
    
    @ViewBuilder
    func rootView() -> some View {
        TabBarView(repository: repository, mediaStorage: mediaStorage, tabBarCoordinator: self)
    }
    
    func selectTab(tab: TabBarItem) {
        if selectedTab == tab {
            coordinator(for: selectedTab)?.closeAllChild()
        } else {
            switch tab {
            case .trending, .discovery, .favorite, .userProfile:
                selectedTab = tab
            }
        }
    }
    
    var discoverTab: some View {
        if discoverCoordinator == nil {
            discoverCoordinator = DiscoverCoordinator(repository: repository, moviesStorage: mediaStorage)
        }
        return DiscoverCoordinatorView(coordinator: discoverCoordinator!)
    }
    
    var trendingTab: some View {
        if trendingCoordinator == nil {
        trendingCoordinator = TrendingCoordinator(repository: repository, mediaStorage: mediaStorage)
        }
            return TrendingCoordinatorView(coordinator: trendingCoordinator!)
    }
    
    var favoritesTab: some View {
        if favoritesCoordinator == nil {
            favoritesCoordinator = FavoritesCoordinator(repository: repository, mediaStorage: mediaStorage)
        }
        return FavoritesRootView(coordinator: favoritesCoordinator!)
    }
    
    var userTab: some View {
        UserView(viewModel: UserViewModel(repository: repository))
    }
    
    private func setupCoordinators() {
        favoritesCoordinator = FavoritesCoordinator(repository: repository, mediaStorage: mediaStorage)
        discoverCoordinator = DiscoverCoordinator(repository: repository, moviesStorage: mediaStorage)
        trendingCoordinator = TrendingCoordinator(repository: repository, mediaStorage: mediaStorage)
    }
    
    private func coordinator(for selectedTab: TabBarItem) -> (any Coordinator)? {
        switch selectedTab {
        case .trending:
            return trendingCoordinator
        case .discovery:
            return discoverCoordinator
        case .favorite:
            return favoritesCoordinator
        case .userProfile:
            return nil
        }
    }
}
