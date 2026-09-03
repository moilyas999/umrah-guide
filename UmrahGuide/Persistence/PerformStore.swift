import Combine
import Foundation

/// On-device place-in-the-rite persistence. UserDefaults only; nothing leaves the device.
final class PerformStore: ObservableObject {
    static let indexStorageKey = "ai.desklink.umrahguide.perform.stepIndex"
    static let doneStorageKey = "ai.desklink.umrahguide.perform.doneIDs"

    @Published private(set) var stepIndex: Int
    @Published private(set) var doneIDs: Set<String>

    private let defaults: UserDefaults
    private let indexKey: String
    private let doneKey: String

    init(
        defaults: UserDefaults = .standard,
        indexKey: String = PerformStore.indexStorageKey,
        doneKey: String = PerformStore.doneStorageKey
    ) {
        self.defaults = defaults
        self.indexKey = indexKey
        self.doneKey = doneKey

        let storedIndex = defaults.object(forKey: indexKey) as? Int ?? 0
        self.stepIndex = Self.clamped(storedIndex)
        let storedDone = defaults.stringArray(forKey: doneKey) ?? []
        self.doneIDs = Set(storedDone)
    }

    var currentStep: PerformStep {
        PerformCatalog.steps[stepIndex]
    }

    var isFirst: Bool { stepIndex == 0 }
    var isLast: Bool { stepIndex >= PerformCatalog.steps.count - 1 }

    var progress: Double {
        let total = PerformCatalog.steps.count
        guard total > 1 else { return 1 }
        return Double(stepIndex) / Double(total - 1)
    }

    func isDone(_ id: String) -> Bool {
        doneIDs.contains(id)
    }

    func toggleDone(_ id: String) {
        if doneIDs.contains(id) {
            doneIDs.remove(id)
        } else {
            doneIDs.insert(id)
        }
        persistDone()
    }

    func setDone(_ id: String, isDone: Bool) {
        if isDone {
            doneIDs.insert(id)
        } else {
            doneIDs.remove(id)
        }
        persistDone()
    }

    func goTo(index: Int) {
        stepIndex = Self.clamped(index)
        persistIndex()
    }

    func goTo(stepID: String) {
        if let index = PerformCatalog.steps.firstIndex(where: { $0.id == stepID }) {
            goTo(index: index)
        }
    }

    func advance() {
        guard !isLast else { return }
        goTo(index: stepIndex + 1)
    }

    func goBack() {
        guard !isFirst else { return }
        goTo(index: stepIndex - 1)
    }

    func jumpToStage(_ stage: PerformStage) {
        if let index = PerformCatalog.steps.firstIndex(where: { $0.stage == stage }) {
            goTo(index: index)
        }
    }

    func reset() {
        stepIndex = 0
        doneIDs.removeAll()
        persistIndex()
        persistDone()
    }

    func doneCount(in stage: PerformStage) -> Int {
        PerformCatalog.steps.filter { $0.stage == stage && doneIDs.contains($0.id) }.count
    }

    private func persistIndex() {
        defaults.set(stepIndex, forKey: indexKey)
    }

    private func persistDone() {
        defaults.set(Array(doneIDs).sorted(), forKey: doneKey)
    }

    private static func clamped(_ index: Int) -> Int {
        let last = max(PerformCatalog.steps.count - 1, 0)
        return min(max(index, 0), last)
    }
}
