//
//  VideoPlayer.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-06-17.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
import AVKit
import SwiftUI

/// This view can be used to stream videos.
///
/// This view wraps a `VideoPlayerController` then loads the
/// provided video url into an `AVPlayer`. You can inject an
/// optional `time` binding (seconds). If you do, your video
/// playback will start at the provided time and future time
/// changes will be written back to the binding.
///
/// You can inject a `didPlayToEndAction` action to define a
/// custom action to trigger when the player reaches the end.
///
/// You can configure the view by applying the view modifier
/// ``SwiftUICore/View/videoPlayerConfiguration(_:)``.
public struct VideoPlayer: UIViewControllerRepresentable {

    /// Create a video player.
    ///
    /// - Parameters:
    ///   - videoURL: The video URL to play.
    ///   - time: An external player time binding, if any.
    ///   - configuration: The player configuration to apply, by default ``VideoPlayerConfiguration/standard``.
    ///   - controllerConfiguration: The controller configuration to apply, if any.
    ///   - didPlayToEndAction: An action to trigger when the player reaches the end, if any.
    public init(
        videoURL: URL?,
        time: Binding<Double>? = nil,
        configuration: VideoPlayerConfiguration = .standard,
        controllerConfiguration: @escaping (VideoPlayerController) -> () = { _ in },
        didPlayToEndAction: Action? = nil
    ) {
        self.videoURL = videoURL
        self.time = time
        self.configuration = configuration
        self.controllerConfiguration = controllerConfiguration
        self.didPlayToEndAction = didPlayToEndAction
    }

    @Environment(\.dismiss) var dismiss

    public typealias Action = () -> Void

    private let videoURL: URL?
    private let time: Binding<Double>?
    private let configuration: VideoPlayerConfiguration
    private let controllerConfiguration: (VideoPlayerController) -> ()
    private let didPlayToEndAction: Action?
}

/// This type can be used to configure a ``VideoPlayer``.
public struct VideoPlayerConfiguration: Sendable {

    /// Create a custom video player configuration.
    ///
    /// - Parameters:
    ///   - autoPlay: Whether to auto-play video when the player appears, by default `true`.
    public init(
        autoPlay: Bool = true
    ) {
        self.autoPlay = autoPlay
    }

    /// Whether to auto-play video when the player appears.
    public var autoPlay: Bool
}

public extension VideoPlayerConfiguration {

    /// The standard video player configuration.
    static let standard = VideoPlayerConfiguration()

    /// A list-specific video player configuration with auto
    /// play disabled.
    static let list = VideoPlayerConfiguration(autoPlay: false)
}

public extension VideoPlayer {

    func makeUIViewController(
        context: Context
    ) -> VideoPlayerController {
        let controller = VideoPlayerController()
        controller.showsPlaybackControls = true
        controller.modalPresentationStyle = .fullScreen
        controller.playerTime = time
        controller.playerDidPlayToEndAction = didPlayToEndAction ?? {}
        controllerConfiguration(controller)
        controller.player = createPlayer()
        if configuration.autoPlay {
            controller.player?.play()
        }
        return controller
    }

    func updateUIViewController(
        _ playerController: VideoPlayerController,
        context: Context
    ) {}
}

public extension VideoPlayer {

    /// A sample video URL that can be used to test the view.
    static var sampleVideoURL: URL? {
        .init(string: sampleVideoURLString)
    }

    /// A sample video URL that can be used to test the view.
    static var sampleVideoURLString: String {
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4"
    }
}

private extension VideoPlayer {

    func createPlayer() -> AVPlayer? {
        guard let url = videoURL else { return nil }
        let asset = AVAsset(url: url)
        let item = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: item)
        return player
    }
}

#Preview("Documentation #1") {
    struct ContentView: View {

        var body: some View {
            VideoPlayer(videoURL: VideoPlayer.sampleVideoURL)
                .aspectRatio(16/9, contentMode: .fit)
        }
    }

    return ContentView()
}

#Preview("Documentation #2") {
    struct ContentView: View {

        @State var isVideoPresented = false
        @State var videoTime = TimeInterval.zero

        var body: some View {
            Button("Play video") {
                isVideoPresented = true
            }
            .fullScreenCover(isPresented: $isVideoPresented) {
                VideoPlayer(
                    videoURL: VideoPlayer.sampleVideoURL,
                    time: $videoTime,
                    didPlayToEndAction: { isVideoPresented = false }
                )
                .ignoresSafeArea()
            }
        }
    }

    return ContentView()
}

#Preview("Documentation #3") {
    struct ContentView: View {

        var body: some View {
            VideoPlayer(
                videoURL: VideoPlayer.sampleVideoURL,
                configuration: .init(autoPlay: false),
                controllerConfiguration: { controller in
                    controller.showsPlaybackControls = false
                }
            )
        }
    }

    return ContentView()
}
#endif
