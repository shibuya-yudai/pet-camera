// MARK: - PCTracking: ParallaxCamera

import simd

/// パララックスカメラのパラメータ
public struct ParallaxCameraState: Equatable, Sendable {
    /// カメラの位置オフセット
    public let cameraOffset: SIMD3<Float>
    /// カメラの注視点
    public let lookAt: SIMD3<Float>

    public static let `default` = ParallaxCameraState(
        cameraOffset: .zero,
        lookAt: SIMD3<Float>(0, 0, -1)
    )
}

/// 頭部位置からパララックスカメラのパラメータを計算する（純粋関数）
public enum ParallaxCamera {
    /// パララックスの効果の強さ
    private static let parallaxStrength: Float = 2.5

    /// 部屋の中心（カメラの注視先）
    private static let roomCenter = SIMD3<Float>(0, -0.3, -1.5)

    /// HeadPose からカメラのオフセット位置を計算する
    ///
    /// 原理: ユーザーの目が左に動く → カメラも左にオフセット → 部屋の右側がより見える
    /// これにより「画面 = 窓」のパララックス効果が生まれる
    public static func compute(headPose: HeadPose) -> ParallaxCameraState {
        let eye = headPose.position

        let offsetX = eye.x * parallaxStrength
        let offsetY = eye.y * parallaxStrength

        return ParallaxCameraState(
            cameraOffset: SIMD3<Float>(offsetX, offsetY, 0),
            lookAt: roomCenter
        )
    }
}
