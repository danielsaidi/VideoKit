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
    ///   - duration: The video duration.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    public init(
        videoURL: URL?,
        duration: TimeInterval,
        configuration: VideoSplashScreenConfiguration? = nil
    ) where VideoPlayerView == VideoPlayer {
        self.init(
            videoURL: videoURL,
            duration: duration,
            configuration: configuration,
            videoPlayerView: { $0 }
        )
    }

    /// Create a video splash screen that modifies the video
    /// player view before presenting it.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - duration: The video splash duration.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    ///   - videoPlayerView: A custom video player view builder.
    public init(
        videoURL: URL?,
        duration: TimeInterval,
        configuration: VideoSplashScreenConfiguration? = nil,
        @ViewBuilder videoPlayerView: @escaping (VideoPlayer) -> VideoPlayerView
    ) {
        self.videoURL = videoURL
        self.videoDuration = duration
        self.config = configuration ?? .standard
        self.videoPlayerView = videoPlayerView
    }

    private let videoURL: URL?
    private let videoDuration: TimeInterval
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
                videoPlayerView(.init(videoURL: videoURL))
                    .zIndex(1)
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: config.videoContentMode)
                    .animation(config.dismissAnimation, value: isSplashScreenActive)
                    .transition(.opacity)
                    .task(after: videoDuration) {
                        withAnimation {
                            isSplashScreenActive = false
                        }
                    }
                    .videoPlayerConfiguration { controller in
                        controller.showsPlaybackControls = false
                    }
            }
        }
    }
}

/// This type can be used to configure a video splash screen.
public struct VideoSplashScreenConfiguration: Sendable {

    /// Create a custom video splash screen configuration.
    ///
    /// - Parameters:
    ///   - videoContentMode: The video content mode to use, by default `.fill`.
    ///   - dismissAnimation: The dismiss animation to use, by default `.linear(duration: 1)`.
    ///   - maxDisplayDuration: The max time that the splash screen will be visible, by default `10` seconds.
    public init(
        videoContentMode: ContentMode = .fill,
        dismissAnimation: Animation = .linear(duration: 1),
        maxDisplayDuration: TimeInterval = 10
    ) {
        self.videoContentMode = videoContentMode
        self.dismissAnimation = dismissAnimation
        self.maxDisplayDuration = maxDisplayDuration
    }

    public var dismissAnimation: Animation
    public var videoContentMode: ContentMode
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
    ///   - duration: The video splash duration.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    func videoSplashScreen(
        videoURL: URL?,
        duration: TimeInterval,
        configuration: VideoSplashScreenConfiguration? = nil
    ) -> some View {
        self.modifier(
            VideoSplashScreenViewModifier(
                videoURL: videoURL,
                duration: duration,
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
    ///   - duration: The video splash duration.
    ///   - configuration: The configuration to apply, by default ``VideoSplashScreenConfiguration/standard``.
    ///   - videoPlayerView: A custom video player content builder.
    func videoSplashScreen<VideoPlayerView: View>(
        videoURL: URL?,
        duration: TimeInterval,
        configuration: VideoSplashScreenConfiguration? = nil,
        @ViewBuilder videoPlayerView: @escaping (VideoPlayer) -> VideoPlayerView
    ) -> some View {
        self.modifier(
            VideoSplashScreenViewModifier(
                videoURL: videoURL,
                duration: duration,
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

#Preview {

    Text("Hello, world")
        .videoSplashScreen(
            videoURL: VideoPlayer.sampleVideoURL,
            duration: 3,
            videoPlayerView: { $0.background(Color.red) }
        )
}
#endif
