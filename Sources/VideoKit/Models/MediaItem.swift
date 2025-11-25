//
//  MediaItem.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-11-18.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import Foundation

/// This struct represents a general media item, that can be
/// either a movie, podcast, radio show, etc.
public struct MediaItem: Identifiable, Hashable, Equatable, Sendable {

    public init(
        id: String,
        name: String,
        type: ItemType,
        languageCode: String = "en",
        backgroundCoverURL: URL? = nil,
        listCoverURL: URL? = nil,
        thumbnailCoverURL: URL? = nil,
        subtitles: [Subtitle] = []
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.languageCode = languageCode
        self.backgroundCoverURL = backgroundCoverURL
        self.listCoverURL = listCoverURL
        self.thumbnailCoverURL = thumbnailCoverURL
        self.subtitles = subtitles
    }

    public let id: String
    public let name: String
    public let type: ItemType
    public let languageCode: String

    public let backgroundCoverURL: URL?
    public let listCoverURL: URL?
    public let thumbnailCoverURL: URL?

    public let subtitles: [Subtitle]
}

public extension MediaItem {

    /// This enum defines all supported media item types.
    enum ItemType: String, Sendable {
        case movie
        case podcast
        case radioShow
    }

    /// This enum defines a media item subtitle.
    struct Subtitle: Equatable, Hashable, Sendable {

        public init(
            displayName: String,
            languageCode: String = "en",
            sourceURL: URL
        ) {
            self.displayName = displayName
            self.languageCode = languageCode
            self.sourceURL = sourceURL
        }

        public let displayName: String
        public let languageCode: String
        public let sourceURL: URL
    }


}
