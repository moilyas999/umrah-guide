import Foundation

enum DuaOccasion: String, CaseIterable, Identifiable {
    case ihram
    case enteringHaram
    case firstSightKaaba
    case tawaf
    case maqamIbrahim
    case zamzam
    case sai
    case halqTaqsir
    case general

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ihram: return "Ihram / Talbiyah"
        case .enteringHaram: return "Entering Masjid al-Haram"
        case .firstSightKaaba: return "First sight of the Kaaba"
        case .tawaf: return "Tawaf"
        case .maqamIbrahim: return "Maqam Ibrahim"
        case .zamzam: return "Zamzam"
        case .sai: return "Sa'i"
        case .halqTaqsir: return "Halq / Taqsir"
        case .general: return "General"
        }
    }

    var meaning: String {
        switch self {
        case .ihram: return "Ihram is the sacred state. Talbiyah is the “Here I am, O Allah” chant."
        case .enteringHaram: return "Masjid al-Haram is the Sacred Mosque that surrounds the Kaaba."
        case .firstSightKaaba: return "There is no required script. Any sincere dua is fine."
        case .tawaf: return "Tawaf is walking around the Kaaba seven times."
        case .maqamIbrahim: return "Maqam Ibrahim is the station of Abraham, near the Kaaba."
        case .zamzam: return "The well in the Sacred Mosque. Drink and ask Allah for what you need."
        case .sai: return "Sa'i is walking between the hills Safa and Marwah seven times."
        case .halqTaqsir: return "Halq is shaving. Taqsir is shortening the hair."
        case .general: return "Short words you can use at any moment."
        }
    }

    var performStage: PerformStage? {
        switch self {
        case .ihram:
            return .ihram
        case .enteringHaram, .firstSightKaaba, .tawaf, .maqamIbrahim, .zamzam:
            return .tawaf
        case .sai:
            return .sai
        case .halqTaqsir:
            return .halqTaqsir
        case .general:
            return nil
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
