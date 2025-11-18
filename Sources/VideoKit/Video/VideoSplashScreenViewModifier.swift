//
//  VideoSplashScreenViewModifier.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-06-18.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
import SwiftUI

/// This view modifier can be used to add video-based splash screens to any view.
///
/// A video splash screen will play when the view is presented,  then automatically
/// dismiss itself to reveal the underlying view when the video stops playing.
///
/// You can provide a ``VideoSplashScreenConfiguration`` to configure
/// the splash screen, and a custom view modifier to customize the video player.
///
/// > Note: For now, the splash view duration only takes the video duration into the
/// consideration, not an additional time it may take for the video to be downloaded.
/// As such, this view is best used with local video files.
///
/// You can use the ``SwiftUICore/View/videoSplashScreen(videoURL:)``
/// view modifier or any of its variants, to apply a video splash screen to any view.
public struct VideoSplashScreenViewModifier<VideoPlayerView: View>: ViewModifier {

    /// Create a video splash screen that uses a plain video player content view.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    public init(
        videoURL: URL?,
        configuration: VideoSplashScreenConfiguration? = nil
    ) where VideoPlayerView == VideoPlayer {
        self.init(
            videoURL: videoURL,
            configuration: configuration,
            videoPlayerView: { $0 }
        )
    }

    /// Create a video splash screen with a customized video player content view.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    ///   - videoPlayerView: A custom video player view builder.
    public init(
        videoURL: URL?,
        configuration: VideoSplashScreenConfiguration? = nil,
        @ViewBuilder videoPlayerView: @escaping (VideoPlayer) -> VideoPlayerView
    ) {
        self.videoURL = videoURL
        self.config = configuration ?? .standard
        self.videoPlayerView = videoPlayerView
    }

    private let videoURL: URL?
    private let config: VideoSplashScreenConfiguration
    private let videoPlayerView: (VideoPlayer) -> VideoPlayerView

    @State private var isSplashScreenActive = true

    public func body(
        content: Content
    ) -> some View {
        ZStack {
            content
                .zIndex(0)
            if isSplashScreenActive {
                Color.clear
                    .zIndex(1)
                    .animation(config.dismissAnimation, value: isSplashScreenActive)
                    .transition(.opacity)
                    .task(after: config.maxDisplayDuration) {
                        dismissSplashScreen()
                    }
                    .overlay(playerView)
            }
        }
    }
}

private extension VideoSplashScreenViewModifier {

    @ViewBuilder var playerView: some View {
        if let videoURL {
            videoPlayerView(
                VideoPlayer(
                    videoURL: videoURL,
                    controllerConfiguration: { controller in
                        controller.showsPlaybackControls = false
                    },
                    didPlayToEndAction: dismissSplashScreen
                )
            )
            .ignoresSafeArea()
        }
    }
}

private extension VideoSplashScreenViewModifier {

    func dismissSplashScreen() {
        withAnimation(config.dismissAnimation) {
            isSplashScreenActive = false
        }
    }
}

public extension View {

    /// Apply a video splash screen that uses a plain ``VideoPlayer`` view
    /// and a standard configuration.
    ///
    /// The splash screen will be presented when the view is loaded and dismiss
    /// itself to reveal the underlying view once the video finishes playing.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play, if any.
    @ViewBuilder
    func videoSplashScreen(videoURL: URL?) -> some View {
        self.videoSplashScreen(
            videoURL: videoURL,
            configuration: nil,
            videoPlayerView: { $0 }
        )
    }

    /// Apply a video splash screen that uses a plain ``VideoPlayer`` view
    /// and a custom configuration.
    ///
    /// The splash screen will be presented when the view is loaded and dismiss
    /// itself to reveal the underlying view once the video finishes playing.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play, if any.
    ///   - configuration: The configuration to apply.
    @ViewBuilder
    func videoSplashScreen(
        videoURL: URL?,
        configuration: VideoSplashScreenConfiguration
    ) -> some View {
        self.videoSplashScreen(
            videoURL: videoURL,
            configuration: configuration,
            videoPlayerView: { $0 }
        )
    }

    /// Apply a video splash screen that uses a custom ``VideoPlayer`` view.
    ///
    /// The splash screen will be presented when the view is loaded and dismiss
    /// itself to reveal the underlying view once the video finishes playing. 
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play, if any.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    ///   - videoPlayerView: A custom video player content builder.
    @ViewBuilder
    func videoSplashScreen<VideoPlayerView: View>(
        videoURL: URL?,
        configuration: VideoSplashScreenConfiguration? = nil,
        @ViewBuilder videoPlayerView: @escaping (VideoPlayer) -> VideoPlayerView
    ) -> some View {
        self.modifier(
            VideoSplashScreenViewModifier(
                videoURL: videoURL,
                configuration: configuration,
                videoPlayerView: videoPlayerView
            )
        )
    }
}

private extension View {

    func task(
        after time: TimeInterval,
        action: @escaping () -> Void
    ) -> some View {
        self.task {
            let nanosec = UInt64(time * 1_000_000_000.0)
            try? await Task.sleep(nanoseconds: nanosec)
            action()
        }
    }
}

#Preview("Documentation #1") {

    struct ContentView: View {

        var body: some View {
            Text("Hello, world")
                .videoSplashScreen(
                    videoURL: VideoPlayer.sampleVideoURL
                )
        }
    }

    return ContentView()
}

#Preview("Documentation #2") {

    struct ContentView: View {

        var body: some View {
            Text("Hello, world")
                .videoSplashScreen(
                    videoURL: VideoPlayer.sampleVideoURL,
                    configuration: .init(
                        dismissAnimation: .linear(duration: 2),
                        maxDisplayDuration: 2
                    )
                )
        }
    }

    return ContentView()
}

#Preview("Documentation #3") {

    struct ContentView: View {

        var body: some View {
            Text("Hello, world")
                .videoSplashScreen(
                    videoURL: VideoPlayer.sampleVideoURL,
                    videoPlayerView: { videoPlayer in
                        Color.red
                        videoPlayer.aspectRatio(contentMode: .fit)
                    }
                )
        }
    }

    return ContentView()
}
#endif
