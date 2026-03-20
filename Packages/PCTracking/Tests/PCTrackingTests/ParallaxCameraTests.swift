import simd
import Testing
@testable import PCTracking

@Suite("ParallaxCamera")
struct ParallaxCameraTests {
    @Test("正面の目の位置ではカメラオフセットがゼロ")
    func centerEyeProducesZeroOffset() {
        let pose = HeadPose(position: SIMD3<Float>(0, 0, 0.4))
        let state = ParallaxCamera.compute(headPose: pose)
        #expect(state.cameraOffset.x == 0)
        #expect(state.cameraOffset.y == 0)
    }

    @Test("目が右に動くとカメラも右にオフセットする")
    func rightEyeProducesRightOffset() {
        let pose = HeadPose(position: SIMD3<Float>(0.05, 0, 0.4))
        let state = ParallaxCamera.compute(headPose: pose)
        #expect(state.cameraOffset.x > 0)
    }

    @Test("目が上に動くとカメラも上にオフセットする")
    func upEyeProducesUpOffset() {
        let pose = HeadPose(position: SIMD3<Float>(0, 0.03, 0.4))
        let state = ParallaxCamera.compute(headPose: pose)
        #expect(state.cameraOffset.y > 0)
    }

    @Test("default 状態のカメラオフセットはゼロ")
    func defaultStateIsZero() {
        let state = ParallaxCameraState.default
        #expect(state.cameraOffset == .zero)
    }
}
