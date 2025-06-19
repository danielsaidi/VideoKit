//
//  ContentView.swift
//  Demo
//
//  Created by Daniel Saidi on 2025-06-18.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI
import VideoKit

struct ContentView: View {

    enum VideoMode: String { case inline, modal }

    @State var sampleVideos: [SampleVideo] = []
    @State var selection: SampleVideo?

    @AppStorage("LaunchVideo") var isVideoSplashScreenEnabled = true
    @AppStorage("VideoMode") var videoMode = VideoMode.modal

    let gridColums: [GridItem] = [.init(.adaptive(minimum: 450, maximum: 1_000))]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: gridColums) {
                    ForEach(sampleVideos) { sampleVideo in
                        switch videoMode {
                        case .inline: videoListItem(for: sampleVideo)
                        case .modal: thumbnailListItem(for: sampleVideo)
                        }
                    }
                }
            }
            .navigationTitle("Demo")
            .fullScreenCover(item: $selection) { sampleVideo in
                videoPlayer(for: sampleVideo)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Toggle("Launch Video", isOn: $isVideoSplashScreenEnabled)
                        Section {
                            Picker("Video Mode", selection: $videoMode) {
                                Text("Modal Videos").tag(VideoMode.modal)
                                Text("Inline Videos").tag(VideoMode.inline)
                            }
                        }
                    } label: {
                        Label("Menu", systemImage: "gear")
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
        .task { fetchSampleVideos() }
        .videoSplashScreen(
            videoURL: videoSplashUrl,
            isEnabled: isVideoSplashScreenEnabled,
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

    func thumbnailListItem(for video: SampleVideo) -> some View {
        Button {
            selection = video
        } label: {
            DemoListItem(video: video) { video in
                RobustAsyncImage(url: video.thumbnailUrl)
            }
        }
    }

    func videoListItem(for video: SampleVideo) -> some View {
        DemoListItem(video: video) { video in
            VideoPlayer(
                videoURL: video.videoUrl,
                configuration: .list,
                controllerConfiguration: { controller in
                    // Configure the underlying controller here
                }
            )
            .aspectRatio(16/9, contentMode: .fit)
        }
    }

    func videoPlayer(for video: SampleVideo) -> some View {
        VideoPlayer(
            videoURL: video.videoUrl,
            controllerConfiguration: { controller in
                // Configure the underlying controller here
            }
        )
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
