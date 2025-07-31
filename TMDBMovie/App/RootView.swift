//
//  RootView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 07.06.2025.
//

import SwiftUI

struct RootView: View {
    
    @ObservedObject private var rootCoordinator: RootCoordinator
    
    init(authStore: AuthenticationStore, repository: TMDBRepositoryProtocol, mediaStorage: MoviesStorage) {
        self._rootCoordinator = ObservedObject(wrappedValue: RootCoordinator(authStore: authStore, repository: repository, mediaStorage: mediaStorage))
    }
    
    var body: some View {
        rootCoordinator.rootView()
    }
}
