import Combine
import Foundation

/// On-device checklist persistence. Uses UserDefaults only; nothing leaves the device.
final class ChecklistStore: ObservableObject {
    static let defaultStorageKey = "ai.desklink.umrahguide.checklist.checkedIDs"

    @Published private(set) var checkedIDs: Set<String>

    private let defaults: UserDefaults
    private let storageKey: String

    init(
        defaults: UserDefaults = .standard,
        storageKey: String = ChecklistStore.defaultStorageKey
    ) {
        self.defaults = defaults
        self.storageKey = storageKey
        let stored = defaults.stringArray(forKey: storageKey) ?? []
        self.checkedIDs = Set(stored)
    }

    func isChecked(_ id: String) -> Bool {
        checkedIDs.contains(id)
    }

    func toggle(_ id: String) {
        if checkedIDs.contains(id) {
            checkedIDs.remove(id)
        } else {
            checkedIDs.insert(id)
        }
        persist()
    }

    func setChecked(_ id: String, isChecked: Bool) {
        if isChecked {
            checkedIDs.insert(id)
        } else {
            checkedIDs.remove(id)
        }
        persist()
    }

    func reset() {
        checkedIDs.removeAll()
        persist()
    }

    func checkedCount(in items: [ChecklistItem]) -> Int {
        items.reduce(into: 0) { count, item in
            if checkedIDs.contains(item.id) {
                count += 1
            }
        }
    }

    private func persist() {
        defaults.set(Array(checkedIDs).sorted(), forKey: storageKey)
    }
}
