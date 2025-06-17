//
//  VideoSessionManager.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-06-17.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import AVKit
import SwiftUI

/// This protocol can be implemented by any type that should
/// be able to set up a video session.
protocol VideoSessionManager {}

extension VideoSessionManager {

    /// Set up the shared audio/video session for long video.
    func setupVideoSession() throws {
        #if os(iOS) || os(visionOS)
        try AVAudioSession.sharedInstance()
            .setCategory(.playback, mode: .moviePlayback, policy: .longFormVideo)
        #else
        try AVAudioSession.sharedInstance()
            .setCategory(.playback, mode: .moviePlayback)
        #endif
    }
}
