// MARK: - PCCore: PetBrain

import Foundation

/// ユーティリティAI でペットの行動を選択する
public final class PetBrain: Sendable {
    // MARK: - ActionChain

    /// 行動チェーン: ある行動の後に自然に続く行動
    private struct ActionChain: Sendable {
        let trigger: PetAction
        let followUp: PetAction
        let probability: Float
    }

    private static let chains: [ActionChain] = [
        ActionChain(trigger: .yawn, followUp: .stretch, probability: 0.7),
        ActionChain(trigger: .stretch, followUp: .walk, probability: 0.5),
        ActionChain(trigger: .sleep, followUp: .yawn, probability: 0.8),
        ActionChain(trigger: .walk, followUp: .sniff, probability: 0.4),
        ActionChain(trigger: .sniff, followUp: .sit, probability: 0.3),
    ]

    public init() {}

    // MARK: - 行動選択

    /// 現在の欲求と文脈から最適な行動を選択する
    public func selectAction(
        needs: PetNeeds,
        previousAction: PetAction,
        isUserWatching: Bool
    ) -> PetAction {
        // 1. 行動チェーンのチェック
        if let chained = evaluateChain(previous: previousAction) {
            return chained
        }

        // 2. ユーティリティスコアリング
        let candidates = scoredActions(needs: needs, isUserWatching: isUserWatching)
        return selectWithNoise(from: candidates)
    }

    // MARK: - ユーティリティスコアリング

    private func scoredActions(
        needs: PetNeeds,
        isUserWatching: Bool
    ) -> [(PetAction, Float)] {
        [
            (.idle, scoreIdle(needs)),
            (.sleep, scoreSleep(needs)),
            (.walk, scoreWalk(needs)),
            (.sit, scoreSit(needs)),
            (.lookAtCamera, scoreLookAtCamera(needs, isUserWatching: isUserWatching)),
            (.tailWag, scoreTailWag(needs, isUserWatching: isUserWatching)),
            (.yawn, scoreYawn(needs)),
            (.sniff, scoreSniff(needs)),
            (.bark, scoreBark(needs)),
        ]
    }

    private func scoreIdle(_ n: PetNeeds) -> Float {
        0.2
    }

    private func scoreSleep(_ n: PetNeeds) -> Float {
        n.sleepiness * n.sleepiness
    }

    private func scoreWalk(_ n: PetNeeds) -> Float {
        n.boredom * n.energy * 0.8
    }

    private func scoreSit(_ n: PetNeeds) -> Float {
        (1 - n.energy) * 0.4
    }

    private func scoreYawn(_ n: PetNeeds) -> Float {
        n.sleepiness * 0.5
    }

    private func scoreSniff(_ n: PetNeeds) -> Float {
        n.curiosity * n.energy * 0.6
    }

    private func scoreBark(_ n: PetNeeds) -> Float {
        n.boredom > 0.8 ? 0.5 : 0.05
    }

    private func scoreLookAtCamera(_ n: PetNeeds, isUserWatching: Bool) -> Float {
        guard isUserWatching else { return 0.05 }
        return n.affection * 0.9
    }

    private func scoreTailWag(_ n: PetNeeds, isUserWatching: Bool) -> Float {
        guard isUserWatching else { return 0.02 }
        return n.affection > 0.5 ? n.affection * 0.7 : 0.1
    }

    // MARK: - ランダムノイズ付き選択

    /// 最高スコアの行動に若干のノイズを加えて自然さを出す
    private func selectWithNoise(from candidates: [(PetAction, Float)]) -> PetAction {
        let noised = candidates.map { action, score in
            (action, score + Float.random(in: 0 ... 0.1))
        }
        return noised.max(by: { $0.1 < $1.1 })?.0 ?? .idle
    }

    // MARK: - 行動チェーン

    private func evaluateChain(previous: PetAction) -> PetAction? {
        for chain in Self.chains where chain.trigger == previous {
            if Float.random(in: 0 ... 1) < chain.probability {
                return chain.followUp
            }
        }
        return nil
    }
}
