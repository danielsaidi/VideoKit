//
//  SampleVideoTests.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-06-18.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import Testing
import VideoKit

struct Test {

    @Test func canParseLocalSampleVideosFile() async throws {
        let videos = try SampleVideo.librarySampleVideos
        #expect(videos.isEmpty == false)
    }
}
