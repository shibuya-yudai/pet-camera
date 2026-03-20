import Testing
@testable import PCCore

@Suite("PetNeeds")
struct PetNeedsTests {
    @Test("decay で energy が減少し sleepiness が増加する")
    func decayReducesEnergyAndIncreasesSleepiness() {
        var needs = PetNeeds(energy: 0.8, sleepiness: 0.2)
        needs.decay(dt: 10)
        #expect(needs.energy < 0.8)
        #expect(needs.sleepiness > 0.2)
    }

    @Test("decay で値が 0〜1 にクランプされる")
    func decayClamps() {
        var needs = PetNeeds(energy: 0.01, sleepiness: 0.99)
        needs.decay(dt: 100)
        #expect(needs.energy >= 0)
        #expect(needs.sleepiness <= 1)
    }

    @Test("onUserPresent で affection が上昇する")
    func userPresenceIncreasesAffection() {
        var needs = PetNeeds(affection: 0.3)
        needs.onUserPresent()
        #expect(needs.affection > 0.3)
    }

    @Test("apply(completedAction: .sleep) で energy が上昇し sleepiness が減少する")
    func sleepRestoresEnergy() {
        var needs = PetNeeds(energy: 0.3, sleepiness: 0.8)
        needs.apply(completedAction: .sleep)
        #expect(needs.energy > 0.3)
        #expect(needs.sleepiness < 0.8)
    }

    @Test("apply(completedAction: .walk) で boredom が減少する")
    func walkReducesBoredom() {
        var needs = PetNeeds(boredom: 0.7)
        needs.apply(completedAction: .walk)
        #expect(needs.boredom < 0.7)
    }
}
