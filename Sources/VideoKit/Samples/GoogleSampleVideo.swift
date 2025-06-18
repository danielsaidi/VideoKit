//
//  GoogleSampleVideo.swift
//  VideoKit
//
//  Created by Daniel Saidi on 2025-06-18.
//  Copied from https://gist.github.com/jsturgis/3b19447b304616f18657
//

import Foundation

struct GoogleSampleVideo: Codable, Sendable {

    let description: String
    let sources: [String]
    let subtitle: String
    let thumb: String
    let title: String
}

extension GoogleSampleVideo {

    var thumbnailUrl: String {
        thumbBaseUrl + thumb
    }

    var thumbBaseUrl: String {
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/"
    }

    func createSampleVideo() -> SampleVideo {
        .init(
            id: .init(),
            description: description,
            title: title,
            subtitle: subtitle,
            videoUrl: .init(string: sources.first ?? ""),
            thumbnailUrl: .init(string: thumbnailUrl)
        )
    }
}

struct GoogleSampleVideoFileContent: Codable, Sendable {

    let videos: [GoogleSampleVideo]
}

extension GoogleSampleVideo {

    enum FileError: Error {
        case fileNotFound
    }

    static func parseLocalJsonFile() throws -> [SampleVideo] {
        let fileName = "google_sample_videos"
        let fileUrl = Bundle.module.url(forResource: fileName, withExtension: "json")
        do {
            guard let fileUrl else { throw FileError.fileNotFound }
            let data = try Data(contentsOf: fileUrl)
            let content = try JSONDecoder().decode(GoogleSampleVideoFileContent.self, from: data)
            return content.videos.map { $0.createSampleVideo() }
        }
    }
}
