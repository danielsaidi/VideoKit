//
//  VideoSplashScreenViewModifier.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-06-18.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
import SwiftUI

/// This view modifier can be used to add video-based splash
/// screens to any view.
///
/// A video splash screen will play when a view is presented,
/// then automatically dismiss to reveal the underlying view
/// when the video stops playing.
///
/// You can inject a custom ``VideoSplashScreenConfiguration``
/// to customize the splash screen, and inject a custom view
/// modifier to customize the ``VideoPlayer`` view.
///
/// > Note: For now, the splash view duration only takes the
/// video duration into the consideration, not an additional
/// time it may take for the video to be downloaded. As such,
/// this view is best used with local video files.
///
/// You can add a video splash screen to a view by using the
/// ``SwiftUICore/View/videoSplashScreen(videoURL:duration:style:)``
/// view modifier, or the view modifier that lets you adjust
/// the video player before presenting it.
public struct VideoSplashScreenViewModifier<VideoPlayerView: View>: ViewModifier {

    /// Create a video splash screen that uses a plain video
    /// player view as its content.
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

    /// Create a video splash screen that modifies the video
    /// player view before presenting it.
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
                    .videoPlayerConfiguration { controller in
                        controller.showsPlaybackControls = false
                    }
                    .overlay(playerView)
            }
        }
    }
}

private extension VideoSplashScreenViewModifier {

    @ViewBuilder var playerView: some View {
        videoPlayerView(
            VideoPlayer(
                videoURL: videoURL,
                didPlayToEndAction: dismissSplashScreen
            )
        )
        .ignoresSafeArea()
    }
}

private extension VideoSplashScreenViewModifier {

    func dismissSplashScreen() {
        withAnimation(config.dismissAnimation) {
            isSplashScreenActive = false
        }
    }
}

/// This type can be used to configure a video splash screen.
public struct VideoSplashScreenConfiguration: Sendable {

    /// Create a custom video splash screen configuration.
    ///
    /// - Parameters:
    ///   - dismissAnimation: The dismiss animation to use, by default `.linear(duration: 1)`.
    ///   - maxDisplayDuration: The max seconds that the splash screen is presented, by default `10`.
    public init(
        dismissAnimation: Animation = .linear(duration: 1),
        maxDisplayDuration: TimeInterval = 10
    ) {
        self.dismissAnimation = dismissAnimation
        self.maxDisplayDuration = maxDisplayDuration
    }

    /// The video content mode to use.
    public var dismissAnimation: Animation

    /// The max seconds that the splash screen is presented.
    public var maxDisplayDuration: TimeInterval
}

public extension VideoSplashScreenConfiguration {

    /// The standard video splash screen style.
    static let standard = Self()
}

public extension View {

    /// Apply a video splash screen to the view, that uses a
    /// plain ``VideoPlayer`` view as its content.
    ///
    /// The splash screen will be presented when the view is
    /// loaded, then dismiss itself to reveal the underlying
    /// view once the video finishes playing.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    func videoSplashScreen(
        videoURL: URL?,
        configuration: VideoSplashScreenConfiguration? = nil
    ) -> some View {
        self.modifier(
            VideoSplashScreenViewModifier(
                videoURL: videoURL,
                configuration: configuration
            )
        )
    }

    /// Apply a video splash screen to the view, that uses a
    /// modifier ``VideoPlayer`` view as its content.
    ///
    /// The splash screen will be presented when the view is
    /// loaded, then dismiss itself to reveal the underlying
    /// view once the video finishes playing.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    ///   - videoPlayerView: A custom video player content builder.
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
