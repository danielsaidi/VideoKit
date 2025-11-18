//
//  VideoSplashScreenConfiguration.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-11-18.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI


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
