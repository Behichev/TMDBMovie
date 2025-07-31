//
//  RootCoordinator.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

final class RootCoordinator: ObservableObject {
    
    private let authStore: AuthenticationStore
    private let repository: TMDBRepositoryProtocol
    private var mediaStorage: MoviesStorage
    private var tabBarCoordinator: TabBarCoordinator
    
    init(authStore: AuthenticationStore, repository: TMDBRepositoryProtocol, mediaStorage: MoviesStorage) {
        self.authStore = authStore
        self.repository = repository
        self.mediaStorage = mediaStorage
        self.tabBarCoordinator = TabBarCoordinator(repository: repository, mediaStorage: mediaStorage)
    }
    
    
    @ViewBuilder
    func rootView() -> some View {
        if authStore.isAuthenticated {
            tabBarCoordinator.rootView()
                .environmentObject(authStore)
        } else {
            LoginView(repository: repository)
                .environmentObject(authStore)
        }
    }
}
