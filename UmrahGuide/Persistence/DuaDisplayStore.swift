import Combine
import Foundation

/// On-device dua field visibility. UserDefaults only; nothing leaves the device.
final class DuaDisplayStore: ObservableObject {
    static let storageKey = "ai.desklink.umrahguide.display.duaFields"

    @Published private(set) var options: DuaDisplayOptions

    private let defaults: UserDefaults
    private let storageKey: String

    init(
        defaults: UserDefaults = .standard,
        storageKey: String = DuaDisplayStore.storageKey
    ) {
        self.defaults = defaults
        self.storageKey = storageKey
        self.options = Self.load(from: defaults, key: storageKey)
    }

    func toggle(_ field: DuaDisplayField) {
        options = options.toggling(field)
        persist()
    }

    func set(_ field: DuaDisplayField, isOn: Bool) {
        options.set(field, isOn: isOn)
        persist()
    }

    func replace(_ options: DuaDisplayOptions) {
        self.options = options
        persist()
    }

    func resetToDefault() {
        options = .default
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(options) {
            defaults.set(data, forKey: storageKey)
        }
    }

    static func load(from defaults: UserDefaults, key: String) -> DuaDisplayOptions {
        guard let data = defaults.data(forKey: key) else {
            return .default
        }
        return (try? JSONDecoder().decode(DuaDisplayOptions.self, from: data)) ?? .default
    }
}
