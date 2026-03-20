// MARK: - PCFeatures: PetCameraRootView

import PCScene
import SwiftUI

/// ペットカメラのルート View
public struct PetCameraRootView: View {
    @State private var viewModel = PetCameraViewModel()

    public init() {}

    public var body: some View {
        ZStack {
            // 3D シーン
            PetCameraRealityView(scene: viewModel.scene)

            // オーバーレイ
            VStack {
                Spacer()

                if !viewModel.isTracking {
                    trackingBanner
                }
            }
            .padding()
        }
        .task {
            await viewModel.start()
        }
    }

    private var trackingBanner: some View {
        HStack {
            Image(systemName: "face.dashed")
            switch viewModel.trackingCapability {
            case .faceTracking:
                Text("顔を画面に向けてください")
            case .unavailable:
                Text("Face Tracking に対応していないデバイスです")
            }
        }
        .font(.callout)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial, in: Capsule())
    }
}
