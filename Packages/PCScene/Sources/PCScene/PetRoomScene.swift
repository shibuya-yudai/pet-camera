// MARK: - PCScene: PetRoomScene

import PCCore
import PCTracking
import RealityKit
import SwiftUI

/// RealityKit でペットの部屋を描画し、パララックスカメラを制御する
@MainActor
public final class PetRoomScene {
    public let rootEntity = Entity()

    private var cameraEntity: Entity?
    private var petEntity: Entity?

    public init() {}

    // MARK: - シーン構築

    /// シーンをロードして構築する
    public func setup() async {
        // カメラ
        let camera = PerspectiveCamera()
        camera.camera.fieldOfViewInDegrees = 60
        camera.position = SIMD3<Float>(0, 0, 1)
        camera.look(
            at: SIMD3<Float>(0, -0.3, -1.5),
            from: camera.position,
            relativeTo: nil
        )
        rootEntity.addChild(camera)
        cameraEntity = camera

        // 照明
        let sunlight = DirectionalLight()
        sunlight.light.intensity = 1000
        sunlight.light.color = .white
        sunlight.look(
            at: SIMD3<Float>(0, 0, 0),
            from: SIMD3<Float>(2, 4, 2),
            relativeTo: nil
        )
        rootEntity.addChild(sunlight)

        // 床（プレースホルダー）
        let floor = ModelEntity(
            mesh: .generatePlane(width: 3, depth: 3),
            materials: [SimpleMaterial(color: .init(white: 0.9, alpha: 1), isMetallic: false)]
        )
        floor.position = SIMD3<Float>(0, -0.5, -1.5)
        rootEntity.addChild(floor)

        // ペット（プレースホルダー: USDZ が用意できるまで球体で代用）
        let petPlaceholder = ModelEntity(
            mesh: .generateSphere(radius: 0.15),
            materials: [SimpleMaterial(color: .orange, isMetallic: false)]
        )
        petPlaceholder.position = SIMD3<Float>(0, -0.35, -1.5)
        rootEntity.addChild(petPlaceholder)
        petEntity = petPlaceholder
    }

    // MARK: - カメラ更新

    /// パララックスカメラの状態を適用する
    public func updateCamera(_ state: ParallaxCameraState) {
        guard let camera = cameraEntity else { return }
        let newPosition = SIMD3<Float>(
            state.cameraOffset.x,
            state.cameraOffset.y,
            1.0
        )
        camera.position = newPosition
        camera.look(at: state.lookAt, from: newPosition, relativeTo: nil)
    }

    // MARK: - ペットアニメーション

    /// ペットの行動を反映する
    public func applyAction(_ action: PetAction) {
        guard let pet = petEntity else { return }

        // MVP: USDZ アニメーションがないのでプレースホルダー動作
        switch action {
        case .lookAtCamera:
            var transform = pet.transform
            transform.scale = SIMD3<Float>(repeating: 1.1)
            pet.move(to: transform, relativeTo: pet.parent, duration: 0.3)
        case .tailWag:
            let wobble = Transform(
                scale: .one,
                rotation: simd_quatf(angle: 0.1, axis: SIMD3<Float>(0, 1, 0)),
                translation: pet.position
            )
            pet.move(to: wobble, relativeTo: pet.parent, duration: 0.2)
        case .sleep:
            var transform = pet.transform
            transform.scale = SIMD3<Float>(1, 0.7, 1)
            pet.move(to: transform, relativeTo: pet.parent, duration: 0.5)
        case .walk:
            var transform = pet.transform
            let dx = Float.random(in: -0.3 ... 0.3)
            transform.translation = SIMD3<Float>(dx, -0.35, -1.5)
            pet.move(to: transform, relativeTo: pet.parent, duration: 1.0)
        default:
            var transform = pet.transform
            transform.scale = .one
            transform.rotation = simd_quatf(ix: 0, iy: 0, iz: 0, r: 1)
            pet.move(to: transform, relativeTo: pet.parent, duration: 0.3)
        }
    }
}
