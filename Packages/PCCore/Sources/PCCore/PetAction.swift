// MARK: - PCCore: PetAction

/// ペットが取りうる行動
public enum PetAction: Equatable, Sendable {
    case idle
    case sleep
    case walk
    case sit
    case lookAtCamera
    case tailWag
    case yawn
    case stretch
    case sniff
    case bark
}
