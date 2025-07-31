//
//  TabBarView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct TabBarView: View {
    
    @ObservedObject var tabBarCoordinator: TabBarCoordinator
    
//    @StateObject var trendingCoordinator: TrendingCoordinator
//    @StateObject var discoverCoordinator: DiscoverCoordinator
//    @StateObject var favoritesCoordinator: FavoritesCoordinator
    
    let repository: TMDBRepositoryProtocol
    
    init(repository: TMDBRepositoryProtocol, mediaStorage: MoviesStorage, tabBarCoordinator: TabBarCoordinator) {
        self.repository = repository
        self.tabBarCoordinator = tabBarCoordinator
//
//        self._trendingCoordinator =  StateObject(wrappedValue: TrendingCoordinator(repository: repository, mediaStorage: mediaStorage))
//        self._discoverCoordinator =   StateObject(wrappedValue: DiscoverCoordinator(repository: repository, moviesStorage: mediaStorage))
//        self._favoritesCoordinator =  StateObject(wrappedValue: FavoritesCoordinator(repository: repository, mediaStorage: mediaStorage))
    }
    
    enum Assets: String {
        case trendingImageName = "chart.line.uptrend.xyaxis.circle.fill"
        case favoritesImageName = "star.circle.fill"
        case userImageName = "person.crop.circle.fill"
        case discoverImageName = "movieclapper"
    }
    
    var body: some View {
        TabView(selection: $tabBarCoordinator.selectedTab) {
            
            tabBarCoordinator.trendingTab
                .tabItem {
                    Label("Trending", systemImage: Assets.trendingImageName.rawValue)
                }
                .tag(TabBarItem.trending)
            
            tabBarCoordinator.discoverTab
                .tabItem {
                    Label("Movies", systemImage: Assets.discoverImageName.rawValue)
                }
                .tag(TabBarItem.discovery)
            
            tabBarCoordinator.favoritesTab
                .tabItem {
                    Label("Favorites", systemImage: Assets.favoritesImageName.rawValue)
                }
                .tag(TabBarItem.favorite)
            
            tabBarCoordinator.userTab
                .tabItem {
                    Label("Profile", systemImage: Assets.userImageName.rawValue)
                }
                .tag(TabBarItem.userProfile)
        }
//        .onAppear {
//            tabBarCoordinator.trendingCoordinator = trendingCoordinator
//            tabBarCoordinator.discoverCoordinator = discoverCoordinator
//            tabBarCoordinator.favoritesCoordinator = favoritesCoordinator
//        }
    }
}
