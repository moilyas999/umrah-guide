import Foundation

enum PerformStage: String, CaseIterable, Identifiable, Equatable {
    case ihram
    case tawaf
    case sai
    case halqTaqsir

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ihram: return "Ihram"
        case .tawaf: return "Tawaf"
        case .sai: return "Sa'i"
        case .halqTaqsir: return "Hair"
        }
    }

    /// One-line meaning so a pilgrim never has to guess the Arabic term.
    var meaning: String {
        switch self {
        case .ihram: return "The sacred state you enter for Umrah."
        case .tawaf: return "Walking around the Kaaba seven times."
        case .sai: return "Walking between Safa and Marwah seven times."
        case .halqTaqsir: return "Shaving or shortening the hair to leave ihram."
        }
    }

    var systemImage: String {
        switch self {
        case .ihram: return "tshirt"
        case .tawaf: return "arrow.triangle.2.circlepath"
        case .sai: return "figure.walk"
        case .halqTaqsir: return "scissors"
        }
    }

    var ritualID: RitualID {
        switch self {
        case .ihram: return .ihram
        case .tawaf: return .tawaf
        case .sai: return .sai
        case .halqTaqsir: return .halqTaqsir
        }
    }
}

struct PerformStep: Identifiable, Equatable, Hashable {
    let id: String
    let stage: PerformStage
    let title: String
    /// One to three short sentences of what to do right now.
    let doNow: [String]
    /// Optional plain-English gloss for a term used on this step.
    let jargon: String?
    let womenNote: String?
    /// One-line caution, not a lecture.
    let caution: String?
    let primaryDuaID: String?
}
