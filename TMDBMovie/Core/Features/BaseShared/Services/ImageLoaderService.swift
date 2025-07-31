//
//  ImageLoaderService.swift
//  NetworkApp
//
//  Created by Ivan Behichev on 09.05.2025.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL
    private var cancellable: AnyCancellable?
    private(set) var isLoading = false
    
    init(url: URL) {
        self.url = url
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard !isLoading else { return }
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }
    
    private func cancel() {
        cancellable?.cancel()
    }
}

protocol ImageLoaderService {
    func loadImageData(from url: URL) async throws -> Data
    func prepareImagePath(from string: String, size: Int) throws -> URL
}


