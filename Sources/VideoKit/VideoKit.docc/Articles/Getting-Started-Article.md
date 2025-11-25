# Getting Started

This article describes how to get started with VideoKit.

## Video Player

Use the ``VideoPlayer`` view to add video content to your app:


```swift
struct ContentView: View {

    @State var videoTime = TimeInterval.zero

    var body: some View {
        VideoPlayer(
            videoURL: VideoPlayer.sampleVideoURL,
            time: $videoTime,
            configuration: .init(autoPlay: false),
            controllerConfiguration: { controller in
                controller.showsPlaybackControls = false
            },
            didPlayToEndAction: { print("The end") }
        )
        .aspectRatio(16/9, contentMode: .fit)
    }
}
```

The video player is very customizable and supports injecting a time binding for persisting and resuming playback, player and controller configurations, and a custom `didPlayToEndAction` to trigger when playback ends. 


## Video Splash Screen

Use the ``SwiftUICore/View/videoSplashScreen(videoURL:)`` view modifier to apply a video splash screen to your root view:

```swift
struct ContentView: View {

    var body: some View {
        Text("Hello, world")
            .videoSplashScreen(
                videoURL: VideoPlayer.sampleVideoURL,
                configuration: .init(
                    dismissAnimation: .linear(duration: 2),
                    maxDisplayDuration: 2
                ),
                videoPlayerView: { videoPlayer in
                    Color.red
                    videoPlayer.aspectRatio(contentMode: .fit)
                }
            )
    }
}
```

The video splash screen will automatically present itself when your app launches. You can pass in a custom configuration to customize the splash screen, and customize the `videoPlayerView`. 


## Models & Utilities

VideoKit provides media-related models, like ``MediaItem``, and a ``SampleVideo`` with sample videos that you can use while developing your app. There is also an observable ``PaginationContext`` that makes it easy to manage pagination.
