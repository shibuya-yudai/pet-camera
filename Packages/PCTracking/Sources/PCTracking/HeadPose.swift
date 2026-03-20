// MARK: - PCTracking: HeadPose

import Foundation
import simd

/// デバイスから取得した頭部の位置と回転
public struct HeadPose: Sendable {
    /// カメラ座標系での目の位置（メートル単位）
    public let position: SIMD3<Float>
    /// 頭部の回転
    public let rotation: simd_quatf
    /// タイムスタンプ
    public let timestamp: TimeInterval

    public init(
        position: SIMD3<Float>,
        rotation: simd_quatf = simd_quatf(ix: 0, iy: 0, iz: 0, r: 1),
        timestamp: TimeInterval = 0
    ) {
        self.position = position
        self.rotation = rotation
        self.timestamp = timestamp
    }

    /// ユーザーが検出されていないときのデフォルト（正面 40cm）
    public static let `default` = HeadPose(
        position: SIMD3<Float>(0, 0, 0.4)
    )
}
