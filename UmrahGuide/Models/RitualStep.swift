import Foundation

enum RitualID: String, CaseIterable, Identifiable, Equatable {
    case ihram
    case tawaf
    case sai
    case halqTaqsir

    var id: String { rawValue }
}

struct RitualStep: Identifiable, Equatable, Hashable {
    let id: RitualID
    let order: Int
    let title: String
    let subtitle: String
    let systemImage: String
    let whatToDo: [String]
    let commonMistakes: [String]
    let womenNotes: String
}
