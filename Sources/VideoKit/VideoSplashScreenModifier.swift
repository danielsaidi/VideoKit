//
//  VideoSplashScreenModifier.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-06-18.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
import SwiftUI

/// This view modifier adds a video splash screen to a view.
///
/// > Note: For now, the splash view duration only takes the
/// video duration into the consideration, not an additional
/// time it may take for the video to be downloaded. As such,
/// this view is best used with local video files.
///
/// You can add a video splash screen to a view by using the
/// ``SwiftUICore/View/videoSplashScreen(videoURL:duration:)``
/// view modifier.
public struct VideoSplashScreenModifier<VideoPlayerView: View>: ViewModifier {

    /// Create a video splash screen that uses the raw video
    /// player view.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - duration: The video splash duration.
    public init(
        videoURL: URL?,
        duration: TimeInterval
    ) where VideoPlayerView == VideoPlayer {
        self.init(
            videoURL: videoURL,
            duration: duration,
            content: { $0 }
        )
    }

    /// Create a video splash screen that modifies the video
    /// player view before presenting it.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - duration: The video splash duration.
    ///   - content: A custom video player content builder.
    public init(
        videoURL: URL?,
        duration: TimeInterval,
        @ViewBuilder content: @escaping (VideoPlayer) -> VideoPlayerView
    ) {
        self.videoURL = videoURL
        self.videoDuration = duration
        self.videoPlayerView = content
    }

    private let videoURL: URL?
    private let videoDuration: TimeInterval
    private let videoPlayerView: (VideoPlayer) -> VideoPlayerView

    @Environment(\.videoSplashScreenConfiguration) private var config

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
                    .aspectRatio(contentMode: config.contentMode)
                    .videoPlayerConfiguration { controller in
                        controller.showsPlaybackControls = false
                    }
                    .animation(config.dismissAnimation, value: isSplashScreenActive)
                    .transition(.opacity)
                    .task(after: videoDuration) {
                        withAnimation {
                            isSplashScreenActive = false
                        }
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
    ///   - contentMode: The content mode to apply to the player, by default `.fit`.
    ///   - dismissAnimation: The dismiss animation to use, by default `.linear(duration: 1)`.
    public init(
        contentMode: ContentMode = .fit,
        dismissAnimation: Animation = .linear(duration: 1)
    ) {
        self.contentMode = contentMode
        self.dismissAnimation = dismissAnimation
    }

    public var contentMode: ContentMode
    public var dismissAnimation: Animation
}

public extension VideoSplashScreenConfiguration {

    /// The standard video splash screen configuration.
    static let standard = Self()
}

public extension EnvironmentValues {

    /// This value can be used to configure a video splash screen.
    @Entry var videoSplashScreenConfiguration = VideoSplashScreenConfiguration.standard
}

public extension View {

    /// Apply a custom ``VideoSplashScreenConfiguration``.
    func videoSplashScreenConfiguration(
        _ config: VideoSplashScreenConfiguration
    ) -> some View {
        self.environment(\.videoSplashScreenConfiguration, config)
    }
}

public extension View {

    /// Play a certain video as splash screen when this view
    /// is presented for the first time.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - duration: The video splash duration.
    func videoSplashScreen(
        videoURL: URL?,
        duration: TimeInterval
    ) -> some View {
        self.modifier(
            VideoSplashScreenModifier(
                videoURL: videoURL,
                duration: duration
            )
        )
    }

    /// Play a certain video as splash screen when this view
    /// is presented for the first time, with custom content
    /// being applied to the video player.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - duration: The video splash duration.
    ///   - content: A custom video player content builder.
    func videoSplashScreen<VideoPlayerView: View>(
        videoURL: URL?,
        duration: TimeInterval,
        @ViewBuilder content: @escaping (VideoPlayer) -> VideoPlayerView
    ) -> some View {
        self.modifier(
            VideoSplashScreenModifier(
                videoURL: videoURL,
                duration: duration,
                content: content
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
            content: { $0.background(Color.red) }
        )
        .videoSplashScreenConfiguration(.init(
            contentMode: .fit,
            dismissAnimation: .linear(duration: 4)
        ))
}
#endif
