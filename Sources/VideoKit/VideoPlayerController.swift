//
//  VideoPlayerController.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-06-17.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
import AVKit
import SwiftUI

@MainActor
public final class VideoPlayerController: AVPlayerViewController, VideoSessionManager {

    /// TODO: Verify that this works, since it will crash if
    /// we're not in an isolated context. If it doesn't work,
    /// we need to call `destroyPlayer` from the outside.
    deinit {
        MainActor.assumeIsolated {
            destroyPlayer()
        }
    }

    #if os(iOS)
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }

    public override var prefersHomeIndicatorAutoHidden: BooleanLiteralType {
        true
    }
    #endif


    // MARK: - Properties

    public override var player: AVPlayer? {
        didSet {
            try? setupVideoSession()
            addTimeObserver()
            addStatusObserver()
            addFinishPlayingObservation()
        }
    }

    private var isInitialPlay = true
    private var statusObserver: NSKeyValueObservation?
    private var timeObserver: Any?

    let timeObserverInterval: Double = 0.5
    let timeScale = CMTimeScale(NSEC_PER_SEC)

    var playerDidPlayToEndAction = {}
    var playerTime: Binding<Double>?
}


// MARK: - Player Control

extension VideoPlayerController {

    func destroyPlayer() {
        player?.pause()
        removeStatusObserver()
        removeTimeObserver()
    }
}

@objc private extension VideoPlayerController {

    func handlePlayerDidPlayToEndTime() {
        playerDidPlayToEndAction()
    }
}


// MARK: - Observations

private extension VideoPlayerController {

    func addFinishPlayingObservation() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePlayerDidPlayToEndTime),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    func addStatusObserver() {
        removeStatusObserver()
        statusObserver = player?.observe(\.status) { [weak self] player, _ in
            guard let self = self else { return }
            Task { @MainActor in
                guard self.isInitialPlay, player.status == .readyToPlay else { return }
                self.isInitialPlay = false
                guard let time = self.playerTime?.wrappedValue else { return }
                player.seek(to: createTime(atSeconds: time))
            }
        }
    }

    func addTimeObserver() {
        removeTimeObserver()
        let interval = createTime(atSeconds: timeObserverInterval)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                guard let seconds = player?.currentTime().seconds else { return }
                playerTime?.wrappedValue = seconds
            }
        }
    }

    func createTime(
        atSeconds seconds: Double
    ) -> CMTime {
        CMTime(seconds: seconds, preferredTimescale: timeScale)
    }

    func removeStatusObserver() {
        statusObserver?.invalidate()
    }

    func removeTimeObserver() {
        guard let observer = timeObserver else { return }
        player?.removeTimeObserver(observer)
        timeObserver = nil
    }

}

#endif
