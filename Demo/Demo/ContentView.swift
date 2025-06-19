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

    let gridColums: [GridItem] = [.init(.adaptive(minimum: 450, maximum: 1_000))]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: gridColums) {
                    ForEach(sampleVideos) { sampleVideo in
                        listItem(for: sampleVideo)
                    }
                }
            }
            .navigationTitle("Demo")
            .fullScreenCover(item: $selection) { sampleVideo in
                videoPlayer(for: sampleVideo)
            }
        }
        .task { fetchSampleVideos() }
        .videoSplashScreen(
            videoURL: videoSplashUrl,
            configuration: .demo,
            videoPlayerView: { videoPlayer in
                ZStack {
                    Color.black
                    videoPlayer
                }
            }
        )
    }
}

extension ContentView {

    var videoSplashUrl: URL? {
        Bundle.main.url(forResource: "DemoSplash", withExtension: "mp4")
    }

    func fetchSampleVideos() {
        let videos = try? SampleVideo.librarySampleVideos
        sampleVideos = videos ?? []
    }

    func listItem(for video: SampleVideo) -> some View {
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

    func videoPlayer(for video: SampleVideo) -> some View {
        VideoPlayer(videoURL: video.videoUrl)
            .ignoresSafeArea()
            .videoPlayerConfiguration { controller in
                // Configure player here...
            }
    }
}

extension VideoSplashScreenConfiguration {

    static var demo: Self {
        VideoSplashScreenConfiguration(
            dismissAnimation: .linear(duration: 2)
        )
    }
}

extension URL: @retroactive Identifiable {

    public var id: String { absoluteString }
}

#Preview {
    ContentView()
}
