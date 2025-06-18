//
//  ContentView.swift
//  Demo
//
//  Created by Daniel Saidi on 2025-06-18.
//

import SwiftUI
import VideoKit

struct ContentView: View {

    @State var videoURL: URL?

    let videoURLStrings: [String] = [
        VideoPlayer.sampleVideoURLString
    ]

    var videoUrls: [URL?] {
        var urls: [URL?] = videoURLStrings.compactMap(URL.init)
        urls.append(Bundle.main.url(forResource: "BigBuckBunny", withExtension: "mp4"))
        return urls
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(videoUrls, id: \.self) { url in
                    Button("Hej") {
                        videoURL = url
                    }
                }
            }
            .navigationTitle("Demo")
            .fullScreenCover(item: $videoURL) { url in
                VideoPlayer(videoURL: url)
                    .ignoresSafeArea()
                    .videoPlayerConfiguration { controller in
                        // Configure player here...
                    }
            }
        }
    }
}

extension URL: @retroactive Identifiable {

    public var id: String { absoluteString }
}

#Preview {
    ContentView()
}
