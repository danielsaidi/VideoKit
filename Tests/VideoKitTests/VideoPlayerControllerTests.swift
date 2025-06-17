import AVKit
import Testing
@testable import VideoKit

@MainActor
class VideoPlayerControllerTests {

    @Test func hasValidTimeValues() async throws {
        let controller = VideoPlayerController()
        #expect(controller.timeObserverInterval == 0.5)
        #expect(controller.timeScale == CMTimeScale(NSEC_PER_SEC))
    }
}
