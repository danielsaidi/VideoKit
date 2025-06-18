# ``VideoKit``

A SwiftUI library with a configurable video player and other video-related utilities.


## Overview

![Library logotype](Logo.png)

VideoKit is a SwiftUI library with a configurable ``VideoPlayer`` view, as well as other video-related utilities like a video splash screen.

Unlike AVKit's VideoPlayer, VideoKit's ``VideoPlayer`` can be configured to creat extend, and the video splash screen utilities make it easy to create a video splash screen that plays when your app launches.



## Installation

VideoKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/VideoKit.git
```

> Important: For remote playback to work in macOS Catalyst, you must enable "Outgoing Connections (Client)" under "Signing & Capabilities > App Sandbox" and enable "App Transport Security Settings > Allow Arbitrary Loads" (for more security, specify allowed domains) under the app's "Info" configuration.



## Supported Platforms

VideoKit supports iOS 15, iPadOS 15, macOS 12 Catalyst, tvOS 15, and visionOS 1.



## Support My Work

You can [become a sponsor][Sponsors] to help me dedicate more time on my various [open-source tools][OpenSource]. Every contribution, no matter the size, makes a real difference in keeping these tools free and actively developed.



## Getting Started

### Video Player

To add a video player to your app, just add a ``VideoPlayer`` to any view. You can use the ``SwiftUICore/View/videoPlayerConfiguration(_:)`` view modifier to configure the video player by modifying the underlying ``VideoPlayerController``:

```swift
import SwiftUI
import VideoKit

struct MyView: View {

    var body: some View {
        VideoPlayer(
            videoURL: VideoPlayer.sampleVideoURL
        )
        .aspectRatio(16/9, contentMode: .fit)
        .videoPlayerConfiguration { controller in
            controller.showsPlaybackControls = false
        }
    }
}
```

### Video Splash Screen

To add a video splash screen to your app, like in many of the major video streaming apps, just apply a ``SwiftUICore/View/videoSplashScreen(videoURL:duration:)`` view modifier to the root view of your app:

```swift
import SwiftUI
import VideoKit

struct ContentView: View {

    var body: some View {
        Text("Hello, world")
            .videoSplashScreen(
                videoURL: VideoPlayer.sampleVideoURL,
                duration: 3,
                content: { $0.background(Color.red) }
            )
            .videoSplashScreenConfiguration(.init(
                contentMode: .fit,
                dismissAnimation: .linear(duration: 4)
            ))
    }
}
```

The splash screen will automatically dismiss when the video stops playing.


### Sample Videos

The library comes with a ``SampleVideo`` type that can be used to test the player, and a ``SampleVideo/librarySampleVideos`` collection that is parsed from a JSON file that is embedded within the library.



## Demo Application

The [project repository][Project] has a demo app that lets you explore the library.



## Repository

For more information, source code, etc., visit the [project repository][Project].



## License

VideoKit is available under the MIT license.



## Topics

### Essentials

- ``VideoPlayer``
- ``VideoPlayerController``
- ``VideoSplashScreenModifier``

### Samples

- ``SampleVideo``



[Email]: mailto:daniel.saidi@gmail.com
[Website]: https://danielsaidi.com
[GitHub]: https://github.com/danielsaidi
[OpenSource]: https://danielsaidi.com/opensource
[Sponsors]: https://github.com/sponsors/danielsaidi

[Project]: https://github.com/danielsaidi/VideoKit
