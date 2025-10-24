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
                        case .modal: modalListItem(for: sampleVideo)
                        }
                    }
                }
            }
            .navigationTitle("VideoKit")
            .fullScreenCover(item: $selection) { sampleVideo in
                videoPlayer(for: sampleVideo)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Toggle("Splash Video", isOn: $isVideoSplashScreenEnabled)
                        Section("List") {
                            Picker("Video Mode", selection: $videoMode) {
                                Text("Play in a modal").tag(VideoMode.modal)
                                Text("Play inside the list").tag(VideoMode.inline)
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
            videoURL: isVideoSplashScreenEnabled ? videoSplashUrl : nil,
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

    func modalListItem(for video: SampleVideo) -> some View {
        Button {
            selection = video
        } label: {
            DemoListItem(video: video) { video in
                RobustAsyncImage(url: video.thumbnailUrl)
            }
        }
        .tint(.primary)
    }

    func videoListItem(for video: SampleVideo) -> some View {
        DemoListItem(video: video) { video in
            VideoPlayer(
                videoURL: video.videoUrl,
                time: .constant(30.0),
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
        .ignoresSafeArea()
    }
}

extension VideoSplashScreenConfiguration {

    static var demo: Self {
        .init(dismissAnimation: .linear(duration: 1))
    }
}

extension URL: @retroactive Identifiable {

    public var id: String { absoluteString }
}

#Preview {
    ContentView()
}
