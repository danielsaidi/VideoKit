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
public struct MediaItem: Identifiable, Hashable, Equatable {

    public init(
        id: String,
        name: String,
        type: MediaItemType,
        backgroundCoverURL: URL? = nil,
        listCoverURL: URL? = nil,
        thumbnailCoverURL: URL? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.backgroundCoverURL = backgroundCoverURL
        self.listCoverURL = listCoverURL
        self.thumbnailCoverURL = thumbnailCoverURL
    }

    public let id: String
    public let name: String
    public let type: MediaItemType

    public let backgroundCoverURL: URL?
    public let listCoverURL: URL?
    public let thumbnailCoverURL: URL?
}

/// This enum defines all supported media item types.
public enum MediaItemType {
    case movie
    case podcast
    case radioShow
}
