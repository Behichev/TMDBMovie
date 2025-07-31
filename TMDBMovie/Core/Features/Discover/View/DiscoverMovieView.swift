//
//  DiscoverMovieView.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 16.05.2025.
//

import SwiftUI

struct DiscoverMovieView: View {
    
    @ObservedObject var viewModel: DiscoverMovieViewModel
    let onMediaTapped: (Int) -> Void
    
    var body: some View {
        ScrollView {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
            case .success:
                if viewModel.movieStorage.moviesList.isEmpty {
                    emptyView
                } else {
                    mainContent
                        .padding()
                }
            }
                
        }
        .navigationTitle("Movies")
        .onAppear {
            print("🟡 onAppear for viewModel ID: \(viewModel.id)")
            if !viewModel.isHasLoaded {
               viewModel.loadMovies()
            }
        }
    }
}

//MARK: UI Components

private extension DiscoverMovieView {
    
    var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "movieclapper")
                .font(.largeTitle)
                .foregroundStyle(.primary)
            Text("Movies is empty")
        }
    }
    
    
    var mainContent: some View {
        LazyVStack {
            ForEach(viewModel.movieStorage.moviesList, id: \.id) { movie in
                
                    MediaPreviewCell(media: movie) {
                        viewModel.favoritesToggle(movie)
                    }
                    .onTapGesture {
                        onMediaTapped(movie.id)
                    }
                if viewModel.hasReachedEnd(of: movie) {
                    ProgressView()
                        .tint(.accentColor)
                        .onAppear {
                            if !viewModel.isNextPageLoading {
                                viewModel.loadNextPage()
                            }
                        }
                }
            }
        }
    }
}
