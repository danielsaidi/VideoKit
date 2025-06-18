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

    public init(
        videoURL: URL?,
        time: Binding<Double>? = nil,
        didPlayToEndAction: Action? = nil
    ) {
        self.videoURL = videoURL
        self.time = time
        self.didPlayToEndAction = didPlayToEndAction
    }

    @Environment(\.videoPlayerConfiguration) var configuration
    @Environment(\.dismiss) var dismiss

    public typealias Action = () -> Void

    private let videoURL: URL?
    private let time: Binding<Double>?
    private let didPlayToEndAction: Action?
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
        configuration(controller)
        controller.player = createPlayer()
        controller.player?.play()
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
        let url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        return URL(string: url)
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

public extension EnvironmentValues {

    /// This value can be used to configure a ``VideoPlayer``.
    @Entry var videoPlayerConfiguration: (VideoPlayerController) -> Void = { _ in }
}

public extension View {

    /// Apply a custom ``VideoPlayer`` configuration.
    func videoPlayerConfiguration(
        _ config: @escaping (VideoPlayerController) -> Void
    ) -> some View {
        self.environment(\.videoPlayerConfiguration, config)
    }
}

#Preview {
    return VideoPlayer(
        videoURL: VideoPlayer.sampleVideoURL
    )
}
#endif
