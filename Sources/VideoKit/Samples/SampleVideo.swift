//
//  SampleVideo.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-06-18.
//  Copied from https://gist.github.com/jsturgis/3b19447b304616f18657
//

import Foundation

/// This struct can be used to create sample videos that can
/// be used to test video-related features in your app.
public struct SampleVideo: Codable, Sendable, Identifiable {

    public let id: UUID

    public let description: String
    public let title: String
    public let subtitle: String
    public let videoUrl: URL?
    public let thumbnailUrl: String
}

public extension SampleVideo {

    /// Parse sample videos from a Google-specific JSON file
    /// that is embedded within the library.
    static var librarySampleVideos: [SampleVideo] {
        get throws {
            try GoogleSampleVideo.parseLocalJsonFile()
        }
    }
}
