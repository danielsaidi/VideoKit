//
//  ContentView.swift
//  Demo
//
//  Created by Daniel Saidi on 2025-06-18.
//

import SwiftUI
import VideoKit

struct ContentView: View {

    @State var sampleVideos: [SampleVideo] = []
    @State var selection: SampleVideo?

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: [.init(.adaptive(minimum: 450, maximum: 1_000))]) {
                    ForEach(sampleVideos) { video in
                        Button {
                            selection = video
                        } label: {
                            VStack(alignment: .leading) {
                                RobustAsyncImage(url: video.thumbnailUrl)
                                    .clipShape(.rect(cornerRadius: 10))
                                Text(video.title).font(.title)
                                Text(video.subtitle).foregroundColor(.primary)
                            }
                        }
                        .padding()
                        .multilineTextAlignment(.leading)
                    }
                }
            }
            .navigationTitle("Demo")
            .fullScreenCover(item: $selection) { sample in
                VideoPlayer(videoURL: sample.videoUrl)
                    .ignoresSafeArea()
                    .videoPlayerConfiguration { controller in
                        // Configure player here...
                    }
            }
        }
        .task {
            let videos = try? SampleVideo.librarySampleVideos
            sampleVideos = videos ?? []
        }
    }
}

extension URL: @retroactive Identifiable {

    public var id: String { absoluteString }
}

#Preview {
    ContentView()
}
