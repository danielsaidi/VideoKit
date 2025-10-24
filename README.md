<p align="center">
    <img src="Resources/Icon-Badge.png" alt="Project Icon" width="250" />
</p>

<p align="center">
    <img src="https://img.shields.io/github/v/release/danielsaidi/VideoKit?color=%2300550&sort=semver" alt="Version" />
    <img src="https://img.shields.io/badge/swift-6.0-orange.svg" alt="Swift 6.0" />
    <a href="https://danielsaidi.github.io/VideoKit"><img src="https://img.shields.io/badge/documentation-web-blue.svg" alt="Documentation" /></a>
    <a href="https://github.com/danielsaidi/VideoKit/blob/master/LICENSE"><img src="https://img.shields.io/github/license/danielsaidi/VideoKit" alt="MIT License" /></a>
    <a href="https://github.com/sponsors/danielsaidi"><img src="https://img.shields.io/badge/sponsor-GitHub-red.svg" alt="Sponsor my work" /></a>
</p>


# VideoKit

VideoKit is a SwiftUI library with a configurable ``VideoPlayer`` view, and other utilities like a video splash screen.

<p align="center">
    <img src="https://github.com/danielsaidi/VideoKit/releases/download/0.1/VideoKit-Demo-Compressed.gif" alt="Demo Gif" width="300" />
</p>

Unlike AVKit's VideoPlayer, VideoKit's ``VideoPlayer`` can be configured to great extent. It also lets you observe the current player time and can trigger a custom action when the player reaches the end.

VideoKit can also add customizable, video-based splash screens to your app. This makes it easy to add powerful launch effects, like we see in many video streaming apps.



## Installation

VideoKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/VideoKit.git
```

> [!IMPORTANT]  
> For remote video playback to work in macOS Catalyst, you must enable "Outgoing Connections (Client)" under "Signing & Capabilities > App Sandbox" and enable "App Transport Security Settings > Allow Arbitrary Loads" (for more security, specify allowed domains) under the app's "Info" configuration.



## Supported Platforms

VideoKit supports iOS 15, iPadOS 15, macOS Catalyst 15, tvOS 15, and visionOS 1.



## Support My Work

You can [become a sponsor][Sponsors] to help me dedicate more time on my various [open-source tools][OpenSource]. Every contribution, no matter the size, makes a real difference in keeping these tools free and actively developed.



## Getting Started

### Video Player

To add video content to your app, just add a ``VideoPlayer`` with a URL to the content you want to play:

```swift
struct ContentView: View {

    var body: some View {
        VideoPlayer(videoURL: VideoPlayer.sampleVideoURL)
            .aspectRatio(16/9, contentMode: .fit)
    }
}
```

You can injecting a `time` binding, and trigger an action when the video stops playing:

```swift
struct ContentView: View {

    @State var isVideoPresented = false
    @State var videoTime = TimeInterval.zero

    var body: some View {
        Button("Play video") {
            isVideoPresented = true
        }
        .fullScreenCover(isPresented: $isVideoPresented) {
            VideoPlayer(
                videoURL: VideoPlayer.sampleVideoURL,
                time: $videoTime,
                didPlayToEndAction: { isVideoPresented = false }
            )
            .ignoresSafeArea()
        }
    }
}
```

You can inject a ``VideoPlayerConfiguration`` and a controller configuration to customize the player and its underlying controller:

```swift
struct ContentView: View {

    var body: some View {
        VideoPlayer(
            videoURL: VideoPlayer.sampleVideoURL,
            configuration: .init(autoPlay: false),
            controllerConfiguration: { controller in
                controller.showsPlaybackControls = false
            }
        )
    }
}
```

These options make it easy to add powerful video-based features to your app.  


### Video Splash Screen

VideoKit makes it easy to add a video-based splash screen to your app, that is automatically presented on launch and dismissed when the embedded video stops playing.

To add a video splash screen to your app, just add a ``.videoSplashScreen(videoURL:configuration:)`` view modifier to your app's root view:

```swift
struct ContentView: View {

    var body: some View {
        Text("Hello, world")
            .videoSplashScreen(
                videoURL: VideoPlayer.sampleVideoURL
            )
    }
}
```

You can pass in a ``VideoSplashScreenConfiguration`` to customize the splash screen:

```swift
struct ContentView: View {

    var body: some View {
        Text("Hello, world")
            .videoSplashScreen(
                videoURL: VideoPlayer.sampleVideoURL,
                configuration: .init(
                    dismissAnimation: .linear(duration: 2),
                    maxDisplayDuration: 2
                )
            )
    }
}
```

You can also customize the video player view, for instance to add a custom background view to it:


```swift
struct ContentView: View {

    var body: some View {
        Text("Hello, world")
            .videoSplashScreen(
                videoURL: VideoPlayer.sampleVideoURL,
                videoPlayerView: { videoPlayer in
                    Color.red
                    videoPlayer.aspectRatio(contentMode: .fit)
                }
            )
    }
}
```

These options make it easy to add customizable video splash screens to your app.



### Sample Videos

The library comes with a ``SampleVideo`` type that can be used to test the player, and a ``.librarySampleVideos`` collection that is parsed from a JSON file that is embedded within the library.



## Documentation

The online [documentation][Documentation] has more information, articles, code examples, etc.



## Demo Application

The `Demo` folder has a demo app that lets you explore the library.



## Contact

Feel free to reach out if you have questions, or want to contribute in any way:

* Website: [danielsaidi.com][Website]
* E-mail: [daniel.saidi@gmail.com][Email]
* Bluesky: [@danielsaidi@bsky.social][Bluesky]
* Mastodon: [@danielsaidi@mastodon.social][Mastodon]



## License

VideoKit is available under the MIT license. See the [LICENSE][License] file for more info.



[Email]: mailto:daniel.saidi@gmail.com
[Website]: https://danielsaidi.com
[GitHub]: https://github.com/danielsaidi
[OpenSource]: https://danielsaidi.com/opensource
[Sponsors]: https://github.com/sponsors/danielsaidi

[Bluesky]: https://bsky.app/profile/danielsaidi.bsky.social
[Mastodon]: https://mastodon.social/@danielsaidi
[Twitter]: https://twitter.com/danielsaidi

[Documentation]: https://danielsaidi.github.io/VideoKit
[Getting-Started]: https://danielsaidi.github.io/VideoKit/documentation/videokit/getting-started
[License]: https://github.com/danielsaidi/VideoKit/blob/master/LICENSE
