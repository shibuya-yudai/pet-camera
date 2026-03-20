// MARK: - PCFeatures: PetCameraViewModel

import Foundation
import PCCore
import PCScene
import PCTracking

/// ペットカメラの統合 ViewModel
/// 2つの経路を管理:
/// - 経路A: FaceTracker → ParallaxCamera → PetRoomScene (60fps)
/// - 経路B: PetBrain → PetRoomScene (1Hz)
@MainActor
@Observable
public final class PetCameraViewModel {
    // MARK: - 公開状態

    public private(set) var isTracking = false
    public private(set) var currentAction: PetAction = .idle
    public private(set) var needs: PetNeeds = .init()
    public private(set) var trackingCapability: TrackingCapability = .unavailable

    // MARK: - 依存

    public let scene: PetRoomScene

    private let tracker: any FaceTracking
    private let brain: PetBrain

    // MARK: - 内部状態

    private var trackingTask: Task<Void, Never>?
    private var brainTask: Task<Void, Never>?
    private var isUserWatching = false

    public init(
        tracker: any FaceTracking = ARFaceTracker(),
        brain: PetBrain = PetBrain(),
        scene: PetRoomScene = PetRoomScene()
    ) {
        self.tracker = tracker
        self.brain = brain
        self.scene = scene
        trackingCapability = tracker.capability
    }

    // MARK: - ライフサイクル

    public func start() async {
        await scene.setup()

        // 経路A: 顔トラッキング → パララックス (60fps)
        let stream = tracker.start()
        trackingTask = Task { [weak self] in
            for await pose in stream {
                guard let self else { return }
                isTracking = true
                isUserWatching = true
                let cameraState = ParallaxCamera.compute(headPose: pose)
                scene.updateCamera(cameraState)
            }
            self?.isTracking = false
            self?.isUserWatching = false
        }

        // 経路B: PetBrain 評価 (1Hz)
        brainTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                guard let self else { return }

                needs.decay(dt: 1.0)
                if isUserWatching {
                    needs.onUserPresent()
                }

                let action = brain.selectAction(
                    needs: needs,
                    previousAction: currentAction,
                    isUserWatching: isUserWatching
                )

                if action != currentAction {
                    currentAction = action
                    scene.applyAction(action)
                    needs.apply(completedAction: action)
                }
            }
        }
    }

    public func stop() {
        tracker.stop()
        trackingTask?.cancel()
        brainTask?.cancel()
        trackingTask = nil
        brainTask = nil
        isTracking = false
    }
}
