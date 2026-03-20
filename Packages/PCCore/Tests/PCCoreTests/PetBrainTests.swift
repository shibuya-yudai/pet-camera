import Testing
@testable import PCCore

@Suite("PetBrain")
struct PetBrainTests {
    @Test("高い sleepiness で sleep が選ばれやすい")
    func highSleepinessSelectsSleep() {
        let brain = PetBrain()
        let needs = PetNeeds(energy: 0.2, sleepiness: 0.95, boredom: 0.1, curiosity: 0.1, affection: 0.1, hunger: 0.1)

        // ランダム要素があるので複数回試行
        var sleepCount = 0
        for _ in 0 ..< 20 {
            let action = brain.selectAction(needs: needs, previousAction: .idle, isUserWatching: false)
            if action == .sleep { sleepCount += 1 }
        }
        #expect(sleepCount > 10, "sleep が半数以上選ばれるべき")
    }

    @Test("ユーザーが見ていて affection が高いと lookAtCamera が選ばれやすい")
    func highAffectionWithUserSelectsLookAtCamera() {
        let brain = PetBrain()
        let needs = PetNeeds(energy: 0.5, sleepiness: 0.1, boredom: 0.1, curiosity: 0.1, affection: 0.9, hunger: 0.1)

        var lookCount = 0
        for _ in 0 ..< 20 {
            let action = brain.selectAction(needs: needs, previousAction: .idle, isUserWatching: true)
            if action == .lookAtCamera { lookCount += 1 }
        }
        #expect(lookCount > 5, "lookAtCamera がある程度選ばれるべき")
    }

    @Test("行動チェーン: yawn の後に stretch が発生しうる")
    func yawnCanChainToStretch() {
        let brain = PetBrain()
        let needs = PetNeeds()

        var stretchCount = 0
        for _ in 0 ..< 100 {
            let action = brain.selectAction(needs: needs, previousAction: .yawn, isUserWatching: false)
            if action == .stretch { stretchCount += 1 }
        }
        #expect(stretchCount > 0, "yawn → stretch のチェーンが少なくとも1回は発生すべき")
    }
}
