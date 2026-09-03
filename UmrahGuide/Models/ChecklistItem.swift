import Foundation

enum ChecklistCategory: String, CaseIterable, Identifiable {
    case ihram
    case packing

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ihram: return "Ihram"
        case .packing: return "Packing"
        }
    }

    var systemImage: String {
        switch self {
        case .ihram: return "tshirt"
        case .packing: return "bag"
        }
    }
}

struct ChecklistItem: Identifiable, Equatable, Hashable {
    let id: String
    let category: ChecklistCategory
    let title: String
    let detail: String
}
