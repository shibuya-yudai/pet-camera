// MARK: - PCTracking: FaceTracker

import Foundation

/// Face Tracking の能力
public enum TrackingCapability: Sendable {
    case faceTracking
    case unavailable
}

/// 顔トラッキングのインターフェース
public protocol FaceTracking: Sendable {
    var capability: TrackingCapability { get }
    func start() -> AsyncStream<HeadPose>
    func stop()
}

#if os(iOS)
import ARKit

/// ARKit Face Tracking 実装
public final class ARFaceTracker: NSObject, FaceTracking, ARSessionDelegate, @unchecked Sendable {
    private let session = ARSession()
    private var continuation: AsyncStream<HeadPose>.Continuation?

    public var capability: TrackingCapability {
        ARFaceTrackingConfiguration.isSupported ? .faceTracking : .unavailable
    }

    override public init() {
        super.init()
        session.delegate = self
    }

    public func start() -> AsyncStream<HeadPose> {
        let (stream, continuation) = AsyncStream.makeStream(of: HeadPose.self)
        self.continuation = continuation

        let config = ARFaceTrackingConfiguration()
        config.maximumNumberOfTrackedFaces = 1
        session.run(config)

        return stream
    }

    public func stop() {
        session.pause()
        continuation?.finish()
        continuation = nil
    }

    // MARK: - ARSessionDelegate

    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let face = anchors.first(where: { $0 is ARFaceAnchor }) as? ARFaceAnchor else { return }

        let faceTransform = face.transform
        // フロントカメラの x 軸はミラーされているため反転
        let position = SIMD3<Float>(
            -faceTransform.columns.3.x,
            faceTransform.columns.3.y,
            faceTransform.columns.3.z
        )
        let rotation = simd_quatf(faceTransform)

        let pose = HeadPose(
            position: position,
            rotation: rotation,
            timestamp: face.timestamp
        )
        continuation?.yield(pose)
    }
}
#endif

/// Face Tracking 非対応環境用のスタブ
public final class StubFaceTracker: FaceTracking, @unchecked Sendable {
    public var capability: TrackingCapability {
        .unavailable
    }

    public init() {}

    public func start() -> AsyncStream<HeadPose> {
        AsyncStream { _ in }
    }

    public func stop() {}
}
