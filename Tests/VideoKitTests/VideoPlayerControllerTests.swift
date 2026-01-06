//
//  VideoPlayerControllerTests.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-06-17.
//  Copyright © 2025-2026 Daniel Saidi. All rights reserved.

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(visionOS)
import AVKit
import Testing
@testable import VideoKit

@MainActor
class VideoPlayerControllerTests {

    @Test func hasValidTimeValues() async throws {
        let controller = VideoPlayerController()
        #expect(controller.timeObserverInterval == 0.5)
        #expect(controller.timeScale == CMTimeScale(NSEC_PER_SEC))
    }
}
#endif
