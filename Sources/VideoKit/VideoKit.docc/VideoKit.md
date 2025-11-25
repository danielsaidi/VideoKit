# ``VideoKit``

A SwiftUI library with a video player and other video-related utilities.


## Overview

![Library logotype](Logo.png)

VideoKit is a SwiftUI library with a configurable ``VideoPlayer`` view, and as other video-related functionality like a video splash screen, views, sample data, and Chromecast support.

Unlike AVKit's VideoPlayer, VideoKit's ``VideoPlayer`` can be configured to great extent. It also lets you observe the current player time and can trigger a custom action when the player reaches the end.



## Installation

VideoKit can be installed with the Swift Package Manager:

```
https://github.com/danielsaidi/VideoKit.git
```

> Important: For remote playback to work in macOS Catalyst, you must enable "Outgoing Connections (Client)" under "Signing & Capabilities > App Sandbox" and enable "App Transport Security Settings > Allow Arbitrary Loads" (for more security, specify allowed domains) under the app's "Info" configuration.



## Supported Platforms

VideoKit supports iOS 15, iPadOS 15, macOS Catalyst 15, tvOS 15, and visionOS 1.



## Features

* 🎬 Video Player - A custom ``VideoPlayer`` view.
* ✨ Video Splash Screen - A ``SwiftUICore/View/videoSplashScreen(videoURL:)`` that plays when your app launches.
* 📗 Models - A bunch of video-related models, like ``MediaItem``.
* 🗞️ Pagination - Built-in pagination support with ``PaginationContext``.
* 🍬 Sample Data - Free samples to use while developing.

See the <doc:Getting-Started-Article> article for more information.



## Getting Started

See the <doc:Getting-Started-Article> and <doc:Chromecast-Article> articles for more information. 



## Demo Application

The [project repository][Project] has a demo app that lets you explore the library.



## Repository

For more information, source code, etc., visit the [project repository][Project].



## License

VideoKit is available under the MIT license.



## Topics

### Models

- ``MediaItem``
- ``MediaItemType``

### Pagination

- ``Paginable``
- ``PaginationContext``

### Video

- ``SampleVideo``
- ``VideoPlayer``
- ``VideoPlayerController``
- ``VideoSplashScreenConfiguration``
- ``VideoSplashScreenViewModifier``



[Email]: mailto:daniel.saidi@gmail.com
[Website]: https://danielsaidi.com
[GitHub]: https://github.com/danielsaidi
[OpenSource]: https://danielsaidi.com/opensource
[Sponsors]: https://github.com/sponsors/danielsaidi

[Project]: https://github.com/danielsaidi/VideoKit
