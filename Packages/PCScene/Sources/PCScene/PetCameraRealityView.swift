// MARK: - PCScene: PetCameraRealityView

import RealityKit
import SwiftUI

/// RealityView を SwiftUI にブリッジする
public struct PetCameraRealityView: View {
    let scene: PetRoomScene

    public init(scene: PetRoomScene) {
        self.scene = scene
    }

    public var body: some View {
        RealityView { content in
            content.add(scene.rootEntity)
            content.camera = .spatialTracking
        }
        .ignoresSafeArea()
    }
}
