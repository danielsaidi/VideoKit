//
//  VideoSessionManager.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-06-17.
//  Copyright © 2025-2026 Daniel Saidi. All rights reserved.
//

import AVKit
import SwiftUI

/// This protocol can be implemented by any type that can set up a video session.
protocol VideoSessionManager {}

extension VideoSessionManager {

    /// Set up the shared audio/video session for long video.
    ///
    /// This function only works on iOS, macOS Catalyst, tvOS, and visionOS.
    func setupVideoSession() throws {
        #if os(iOS) || targetEnvironment(macCatalyst) || os(visionOS)
        try AVAudioSession.sharedInstance()
            .setCategory(.playback, mode: .moviePlayback, policy: .longFormVideo)
        #elseif os(tvOS)
        try AVAudioSession.sharedInstance()
            .setCategory(.playback, mode: .moviePlayback)
        #endif
    }
}
