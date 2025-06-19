# Release Notes

VideoKit will use semver after 1.0. 

Until then, breaking changes can happen in any version, and deprecations may be removed in any minor version bump.



## 0.2

This update simplifies how you set up a video splash screen.

### 💡 Adjustments

* You can now apply a custom background view to the splash screen.  
* You can now apply a custom splash screen style in the view modifier.
* `VideoSplashScreenConfiguration` is renamed to `VideoSplashScreenStyle`.

### 🐛 Bug fixes

* The splash screen dismiss animation now works properly.  



## 0.1

This is the first public release of VideoKit.

### ✨ New Features

* `SampleVideo` can provide sample videos.
* `VideoPlayer` view can be used to play videos.
* `VideoSplashScreenModifier` can be used to show brief video splash screens.
