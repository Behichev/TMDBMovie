//
//  FavoritesMoviesView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 24.04.2025.
//

import SwiftUI

struct FavoritesMoviesView: View {
    
    @StateObject var viewModel: FavoritesViewModel
    let onMediaTapped: (Int) -> Void
    
    var body: some View {
        ScrollView {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .tint(.accentColor)
            case .success:
                if viewModel.mediaStorage.favoritesMovies.isEmpty {
                    emptyView
                } else {
                    mainContent
                }
            }
        }
        .navigationTitle("Favorites")
        .refreshable {
            viewModel.fetchFavorites()   
        }
        .onAppear {
            if !viewModel.isLoaded {
                viewModel.fetchFavorites()
            }
        }
    }
}

//MARK: - Components

private extension FavoritesMoviesView {
    
    var mainContent: some View {
        LazyVStack {
            cells
        }
        .padding()
    }
    
    var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "star.fill")
                .font(.largeTitle)
                .foregroundStyle(.primary)
            Text("Favorites is empty")
        }
    }
    
    var cells: some View {
        ForEach(viewModel.mediaStorage.favoritesMovies, id: \.id) { media in
            createCell(with: media)
                .onTapGesture {
                    onMediaTapped(media.id)
                }
        }
    }
    
    @ViewBuilder
    private func createCell(with mediaItem: Media) -> some View {
        MediaPreviewCell(media: mediaItem) {
            withAnimation {
                viewModel.toggleFavorites(mediaItem)
            }
        }
    }
}
