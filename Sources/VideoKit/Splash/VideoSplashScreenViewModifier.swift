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

    /// The standard video splash screen configuration.
    static let standard = Self()
}

public extension View {

    /// Apply a video splash screen that uses a plain ``VideoPlayer`` view.
    ///
    /// The splash screen will be presented when the view is loaded and dismiss
    /// itself to reveal the underlying view once the video finishes playing.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - isEnabled: Whether the splash screen is enabled, by default `true`.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    @ViewBuilder
    func videoSplashScreen(videoURL: URL?) -> some View {
        self.videoSplashScreen(
            videoURL: videoURL,
            isEnabled: true,
            configuration: nil,
            videoPlayerView: { $0 }
        )
    }

    /// Apply a video splash screen that uses a plain ``VideoPlayer`` view.
    ///
    /// The splash screen will be presented when the view is loaded and dismiss
    /// itself to reveal the underlying view once the video finishes playing.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - isEnabled: Whether the splash screen is enabled, by default `true`.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    @ViewBuilder
    func videoSplashScreen(
        videoURL: URL?,
        isEnabled: Bool = true,
        configuration: VideoSplashScreenConfiguration
    ) -> some View {
        self.videoSplashScreen(
            videoURL: videoURL,
            isEnabled: isEnabled,
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
    ///   - videoURL: The video URL to play.
    ///   - isEnabled: Whether the splash screen is enabled, by default `true`.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    ///   - videoPlayerView: A custom video player content builder.
    @ViewBuilder
    func videoSplashScreen<VideoPlayerView: View>(
        videoURL: URL?,
        isEnabled: Bool = true,
        configuration: VideoSplashScreenConfiguration? = nil,
        @ViewBuilder videoPlayerView: @escaping (VideoPlayer) -> VideoPlayerView
    ) -> some View {
        if isEnabled {
            self.modifier(
                VideoSplashScreenViewModifier(
                    videoURL: videoURL,
                    configuration: configuration,
                    videoPlayerView: videoPlayerView
                )
            )
        } else {
            self
        }
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
