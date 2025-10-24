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

    let gridColums: [GridItem] = [.init(.adaptive(minimum: 350, maximum: 1_000))]

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: gridColums) {
                    ForEach(sampleVideos) { sampleVideo in
                        switch videoMode {
                        case .inline: inlineListItem(for: sampleVideo)
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
                                Text("Modal video player").tag(VideoMode.modal)
                                Text("Inline video player").tag(VideoMode.inline)
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
            configuration: .init(
                dismissAnimation: .linear(duration: 1)
            ),
            videoPlayerView: { player in
                player.withBackground(Color.black)
            }
        )
    }
}

private extension ContentView {

    var videoSplashUrl: URL? {
        Bundle.main.url(forResource: "DemoSplash", withExtension: "mp4")
    }

    func fetchSampleVideos() {
        let videos = try? SampleVideo.librarySampleVideos
        sampleVideos = videos ?? []
    }
}

private extension ContentView {

    func inlineListItem(
        for video: SampleVideo
    ) -> some View {
        listItemTemplate(for: video) {
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

    func modalListItem(
        for video: SampleVideo
    ) -> some View {
        Button {
            selection = video
        } label: {
            listItemTemplate(for: video) {
                RobustAsyncImage(url: video.thumbnailUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
        }
        .tint(.primary)
    }

    func listItemTemplate<Content: View>(
        for video: SampleVideo,
        content: () -> Content
    ) -> some View {
        VStack(alignment: .leading) {
            content()
                .clipShape(.rect(cornerRadius: 10))
            Text(video.title)
                .font(.title)
            Text(video.subtitle)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .multilineTextAlignment(.leading)
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

extension URL: @retroactive Identifiable {

    public var id: String { absoluteString }
}

#Preview {
    ContentView()
}
