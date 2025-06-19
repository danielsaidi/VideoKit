//
//  RobustAsyncImage.swift
//  TinkTestAssignment
//
//  Created by Daniel Saidi on 2025-06-04.
//

import SwiftUI

struct RobustAsyncImage: View {

    init(
        url: URL?,
        urlSession: URLSession = .imageSession
    ) {
        self.url = url
        self.urlSession = urlSession
    }

    private let url: URL?
    private let urlSession: URLSession

    @State private var imagePhase: AsyncImagePhase = .empty

    var body: some View {
        Group {
            switch imagePhase {
            case .empty: loadingIndicator.onAppear(perform: loadImage)
            case .success(let image): image.resizable().aspectRatio(contentMode: .fit)
            case .failure: Image(systemName: "exclamationmark.triangle")
            @unknown default: loadingIndicator
            }
        }
    }
}

private extension RobustAsyncImage {

    var loadingIndicator: some View {
        Color.clear
            .aspectRatio(contentMode: .fit)
            .overlay(ProgressView())
    }

    func loadImage() {
        guard let url else { return }
        Task {
            do {
                let (data, _) = try await urlSession.data(from: url)
                if let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        imagePhase = .success(Image(uiImage: uiImage))
                    }
                }
            } catch {
                await MainActor.run {
                    imagePhase = .failure(error)
                }
            }
        }
    }
}

private extension URLSession {

    /// This session is used to make AsyncImage more robust.
    static let imageSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.httpMaximumConnectionsPerHost = 10
        config.timeoutIntervalForRequest = 30
        return URLSession(configuration: config)
    }()
}
