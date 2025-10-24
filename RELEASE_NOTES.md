# Release Notes

[VideoKit](https://github.com/danielsaidi/VideoKit) will use semver after 1.0.

Until then, breaking changes can happen in any minor version.



## 0.4

This version bumps the package to Swift 6.1 and the demo app to iOS 26.

### 💡 Adjustments

* `VideoSplashScreenViewModifier` now avoids redrawing the source view.

### 💥 Breaking Changes

* `VideoSplashScreenViewModifier` no longer has an enabled property.



## 0.3

This update simplifies how you can configure a video player and its underlying controller.

### ✨ New Features

* `VideoPlayer` now lets you inject a player configuration in the initializer.
* `VideoPlayer` now lets you inject a controller configuration in the initializer.
* `VideoPlayerConfiguration` can be used to configure player-specific things, like auto-play.
* `.videoSplashScreen(...)` now allows you to pass in an `isEnabled` argument to conditionally enable the splash screen.



## 0.2

This update simplifies how you set up a video splash screen.

### ✨ New Features

* `VideoSplashScreenViewModifier` now automatically dismisses itself when the video stops playing.
* `VideoSplashScreenViewModifier` has a new configuration argument to customize the splash screen.
* `VideoSplashScreenConfiguration` has a new `maxDisplayDuration` to safeguard against video bugs.

### 🐛 Bug fixes

* The splash screen dismiss animation now works properly. 



## 0.1

This is the first public release of VideoKit.

### ✨ New Features

* `SampleVideo` can provide sample videos.
* `VideoPlayer` view can be used to play videos.
* `VideoSplashScreenModifier` can be used to show brief video splash screens.
