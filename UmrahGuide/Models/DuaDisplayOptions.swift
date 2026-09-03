import Foundation

enum DuaDisplayField: String, CaseIterable, Identifiable, Equatable {
    case arabic
    case transliteration
    case meaning

    var id: String { rawValue }

    var title: String {
        switch self {
        case .arabic: return "Arabic"
        case .transliteration: return "Say it"
        case .meaning: return "Meaning"
        }
    }

    var accessibilityTitle: String {
        switch self {
        case .arabic: return "Arabic"
        case .transliteration: return "Transliteration"
        case .meaning: return "English meaning"
        }
    }
}

/// Which dua fields are visible. Any combination is allowed. Default is all three.
struct DuaDisplayOptions: Equatable, Hashable, Codable {
    var showsArabic: Bool
    var showsTransliteration: Bool
    var showsMeaning: Bool

    static let `default` = DuaDisplayOptions(
        showsArabic: true,
        showsTransliteration: true,
        showsMeaning: true
    )

    var showsAnyText: Bool {
        showsArabic || showsTransliteration || showsMeaning
    }

    func shows(_ field: DuaDisplayField) -> Bool {
        switch field {
        case .arabic: return showsArabic
        case .transliteration: return showsTransliteration
        case .meaning: return showsMeaning
        }
    }

    func toggling(_ field: DuaDisplayField) -> DuaDisplayOptions {
        var next = self
        switch field {
        case .arabic: next.showsArabic.toggle()
        case .transliteration: next.showsTransliteration.toggle()
        case .meaning: next.showsMeaning.toggle()
        }
        return next
    }

    mutating func set(_ field: DuaDisplayField, isOn: Bool) {
        switch field {
        case .arabic: showsArabic = isOn
        case .transliteration: showsTransliteration = isOn
        case .meaning: showsMeaning = isOn
        }
    }
}
