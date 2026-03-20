// MARK: - PCCore: PetNeeds

/// ペットの内部欲求（0.0〜1.0）
public struct PetNeeds: Equatable, Sendable {
    /// 体力。0 = 疲労困憊, 1 = 元気いっぱい
    public var energy: Float
    /// 眠気。0 = 目が冴えてる, 1 = 眠い
    public var sleepiness: Float
    /// 退屈度。0 = 満足, 1 = 退屈
    public var boredom: Float
    /// 好奇心。0 = 落ち着き, 1 = 探索したい
    public var curiosity: Float
    /// 甘えたさ。0 = 自立, 1 = 甘えたい
    public var affection: Float
    /// 空腹度。0 = 満腹, 1 = 空腹
    public var hunger: Float

    public init(
        energy: Float = 0.8,
        sleepiness: Float = 0.2,
        boredom: Float = 0.3,
        curiosity: Float = 0.4,
        affection: Float = 0.3,
        hunger: Float = 0.2
    ) {
        self.energy = energy
        self.sleepiness = sleepiness
        self.boredom = boredom
        self.curiosity = curiosity
        self.affection = affection
        self.hunger = hunger
    }

    // MARK: - 時間経過による自然変動

    /// dt 秒分の欲求を自然に変化させる
    public mutating func decay(dt: Float) {
        energy = clamp(energy - 0.003 * dt)
        sleepiness = clamp(sleepiness + 0.004 * dt)
        boredom = clamp(boredom + 0.005 * dt)
        curiosity = clamp(curiosity + 0.002 * dt)
        affection = clamp(affection + 0.002 * dt)
        hunger = clamp(hunger + 0.003 * dt)
    }

    // MARK: - 行動による欲求変化

    /// 行動を完了したときの欲求変化
    public mutating func apply(completedAction action: PetAction) {
        switch action {
        case .sleep:
            energy = clamp(energy + 0.3)
            sleepiness = clamp(sleepiness - 0.5)
        case .walk, .sniff:
            energy = clamp(energy - 0.05)
            boredom = clamp(boredom - 0.2)
            curiosity = clamp(curiosity - 0.15)
        case .lookAtCamera, .tailWag:
            affection = clamp(affection - 0.2)
        case .yawn, .stretch:
            sleepiness = clamp(sleepiness - 0.05)
        case .bark:
            boredom = clamp(boredom - 0.1)
        case .idle, .sit:
            break
        }
    }

    // MARK: - ユーザーの存在による変化

    /// ユーザーが見ている（Face Tracking 検出中）
    public mutating func onUserPresent() {
        affection = clamp(affection + 0.01)
        boredom = clamp(boredom - 0.005)
    }

    private func clamp(_ value: Float) -> Float {
        min(max(value, 0), 1)
    }
}
