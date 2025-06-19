//
//  DemoListItem.swift
//  Demo
//
//  Created by Daniel Saidi on 2025-06-19.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI
import VideoKit

struct DemoListItem<Header: View>: View {

    let video: SampleVideo
    let header: (SampleVideo) -> Header

    var body: some View {
        VStack(alignment: .leading) {
            header(video)
                .clipShape(.rect(cornerRadius: 10))
            Text(video.title).font(.title)
            Text(video.subtitle).foregroundColor(.primary)
        }
        .padding()
        .multilineTextAlignment(.leading)
    }
}
