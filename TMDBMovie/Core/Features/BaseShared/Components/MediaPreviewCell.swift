//
//  MediaPreviewCell.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 18.04.2025.
//

import SwiftUI

struct MediaPreviewCell: View {
    
    let media: Media
    let onFavoritesTapped: () -> ()
    
    private let imageURL: URL?
    
    init(media: Media, onFavoritesTapped: @escaping () -> Void) {
        self.media = media
        self.onFavoritesTapped = onFavoritesTapped
        self.imageURL = media.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w200\($0)")
        }
    }
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    imageLoaderPlaceholder
                case .success(let image):
                    moviePoster(image)
                case .failure(_):
                    imageLoadErrorPlaceholder
                @unknown default:
                    EmptyView()
                }
            }
                            
            VStack(spacing: 32) {
                VStack(spacing: 8) {
                    HStack {
                        Text(media.name ?? media.title ?? "No title")
                            .font(.headline.bold())
                        
                        Spacer()
                        
                        Button {
                            onFavoritesTapped()
                        } label: {
                            Image(systemName: media.isInFavorites ?? false ? "star.fill" : "star")
                        }
                        .buttonStyle(.plain)
                    }
                    
                    HStack() {
                        Image(systemName: "calendar")
                            .font(.caption2)
                        Text(DateFormatterManager.shared.formattedDate(from: media.releaseDate ?? media.firstAirDate ?? "") ?? "")
                            .font(.footnote)
                        Spacer()
                    }
                }
                Text(media.overview)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
            }
        }
        .background(.clear)
    }
}

private extension MediaPreviewCell {
    var imageLoaderPlaceholder: some View {
        ZStack {
            Color.gray
            ProgressView()
                .tint(.yellow)
        }
        .cornerRadius(20)
        .frame(width: 128, height: 168)
    }
    
    var imageLoadErrorPlaceholder: some View {
        ZStack {
            Color.red
            Image(systemName: "xmark.octagon")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
        }
        .cornerRadius(20)
        .frame(width: 128, height: 168)
    }
    
    @ViewBuilder
    func moviePoster(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
            .frame(width: 128)
            .cornerRadius(Constants.Design.LayoutConstants.cornerRadius.rawValue)
    }
}

//#Preview(traits: .sizeThatFitsLayout) {
//    MediaPreviewCell(media: MockHelper.mockMediaItem) { _ in
//        await MockHelper.setImage("")
//    } onFavoritesTapped: {
//        print("favorite")
//    }
//    .padding()
//}
