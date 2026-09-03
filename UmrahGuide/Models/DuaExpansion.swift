import Foundation

/// Snapshot of one dua row: collapsed title, optional expanded body per filter.
struct CollapsibleDuaPresentation: Equatable, Identifiable {
    let dua: Dua
    let isExpanded: Bool
    let title: String
    let label: String
    let visibleArabic: String?
    let visibleTransliteration: String?
    let visibleMeaning: String?

    var id: String { dua.id }

    var showsAnyBodyText: Bool {
        visibleArabic != nil || visibleTransliteration != nil || visibleMeaning != nil
    }

    var collapsedAccessibilityLabel: String {
        let state = isExpanded ? "Expanded" : "Collapsed"
        return "\(title). \(label). \(state)."
    }
}

/// Collapse / expand rules for dua bodies. Default is every body closed.
enum DuaExpansion {
    /// All dua bodies start collapsed so the pilgrim opens only what they need.
    static func defaultExpandedIDs(for _: [Dua] = []) -> Set<String> {
        []
    }

    static func toggle(_ id: String, in expanded: Set<String>) -> Set<String> {
        var next = expanded
        if next.contains(id) {
            next.remove(id)
        } else {
            next.insert(id)
        }
        return next
    }

    static func collapsedTitle(for dua: Dua) -> String {
        let trimmed = dua.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.lowercased().hasPrefix("dua") {
            return trimmed
        }
        return "Dua for \(trimmed)"
    }

    static func collapsedLabel(for dua: Dua) -> String {
        dua.occasion.title
    }

    /// Duas that belong under a Perform step — not every dua for the whole stage.
    static func duas(for step: PerformStep) -> [Dua] {
        step.relatedDuaIDs.compactMap(DuaCatalog.dua(id:))
    }

    static func presentations(
        duas: [Dua],
        expandedIDs: Set<String>,
        options: DuaDisplayOptions
    ) -> [CollapsibleDuaPresentation] {
        duas.map { dua in
            CollapsibleDuaPresentation(
                dua: dua,
                isExpanded: expandedIDs.contains(dua.id),
                title: collapsedTitle(for: dua),
                label: collapsedLabel(for: dua),
                visibleArabic: options.showsArabic ? dua.arabic : nil,
                visibleTransliteration: options.showsTransliteration ? dua.transliteration : nil,
                visibleMeaning: options.showsMeaning ? dua.meaning : nil
            )
        }
    }

    static func visibleBody(for dua: Dua, options: DuaDisplayOptions) -> (
        arabic: String?,
        transliteration: String?,
        meaning: String?
    ) {
        (
            options.showsArabic ? dua.arabic : nil,
            options.showsTransliteration ? dua.transliteration : nil,
            options.showsMeaning ? dua.meaning : nil
        )
    }
}
