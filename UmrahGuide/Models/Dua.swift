import Foundation

enum DuaOccasion: String, CaseIterable, Identifiable {
    case ihram
    case tawaf
    case sai

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ihram: return "Ihram"
        case .tawaf: return "Tawaf"
        case .sai: return "Sa'i"
        }
    }
}

enum DuaSourceKind: String, Equatable {
    /// Wording taken from the Qur'an; cite the verse only.
    case quran
    /// Widely known wording from authentic collections, without a guessed number.
    case wellKnownAuthentic
    /// Common traditional wording; no isnad or book-number claim.
    case traditionalWording
}

struct Dua: Identifiable, Equatable, Hashable {
    let id: String
    let occasion: DuaOccasion
    let title: String
    let arabic: String
    let transliteration: String
    let meaning: String
    let whenToSay: String
    let sourceKind: DuaSourceKind
    let sourceNote: String
}
