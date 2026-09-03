import Foundation

/// Snapshot of one Umrah stage for the Perform accordion.
struct PerformStagePresentation: Equatable, Identifiable {
    let stage: PerformStage
    let isCurrent: Bool
    let isExpanded: Bool
    let completedCount: Int
    let totalCount: Int
    /// 1-based step inside this stage (current step, or the next undone step).
    let stepNumber: Int
    let actionSummary: String
    let steps: [PerformStep]
    let duas: [Dua]

    var id: PerformStage { stage }

    var progressLabel: String {
        "\(stepNumber) of \(totalCount)"
    }

    var collapsedAccessibilityLabel: String {
        let current = isCurrent ? "Current stage. " : ""
        let expanded = isExpanded ? "Expanded. " : "Collapsed. "
        return "\(current)\(stage.title). Step \(progressLabel). \(actionSummary). \(expanded)\(completedCount) of \(totalCount) checked."
    }
}

enum PerformAccordion {
    static func defaultExpanded(for currentStage: PerformStage) -> Set<PerformStage> {
        [currentStage]
    }

    static func toggle(_ stage: PerformStage, in expanded: Set<PerformStage>) -> Set<PerformStage> {
        var next = expanded
        if next.contains(stage) {
            next.remove(stage)
        } else {
            next.insert(stage)
        }
        return next
    }

    /// Keep the pilgrim's extra expansions, and always open the stage they just moved into.
    static func afterMoving(to stage: PerformStage, expanded: Set<PerformStage>) -> Set<PerformStage> {
        var next = expanded
        next.insert(stage)
        return next
    }

    static func presentations(
        stepIndex: Int,
        doneIDs: Set<String>,
        expandedStages: Set<PerformStage>
    ) -> [PerformStagePresentation] {
        let clamped = min(max(stepIndex, 0), max(PerformCatalog.steps.count - 1, 0))
        let current = PerformCatalog.steps[clamped]

        return PerformStage.allCases.map { stage in
            let steps = PerformCatalog.steps(in: stage)
            let completed = steps.filter { doneIDs.contains($0.id) }.count
            let isCurrent = current.stage == stage
            let (stepNumber, summary) = focusedStep(in: steps, current: current, isCurrent: isCurrent, doneIDs: doneIDs)
            return PerformStagePresentation(
                stage: stage,
                isCurrent: isCurrent,
                isExpanded: expandedStages.contains(stage),
                completedCount: completed,
                totalCount: steps.count,
                stepNumber: stepNumber,
                actionSummary: summary,
                steps: steps,
                duas: uniqueDuas(for: steps)
            )
        }
    }

    private static func focusedStep(
        in steps: [PerformStep],
        current: PerformStep,
        isCurrent: Bool,
        doneIDs: Set<String>
    ) -> (Int, String) {
        if isCurrent, let index = steps.firstIndex(where: { $0.id == current.id }) {
            return (index + 1, current.actionSummary)
        }
        if completedAll(steps, doneIDs: doneIDs), let last = steps.last {
            return (steps.count, last.actionSummary)
        }
        if let next = steps.first(where: { !doneIDs.contains($0.id) }),
           let index = steps.firstIndex(where: { $0.id == next.id }) {
            return (index + 1, next.actionSummary)
        }
        return (1, steps.first?.actionSummary ?? "")
    }

    private static func completedAll(_ steps: [PerformStep], doneIDs: Set<String>) -> Bool {
        !steps.isEmpty && steps.allSatisfy { doneIDs.contains($0.id) }
    }

    private static func uniqueDuas(for steps: [PerformStep]) -> [Dua] {
        var seen = Set<String>()
        var result: [Dua] = []
        for step in steps {
            for id in step.relatedDuaIDs {
                guard !seen.contains(id), let dua = DuaCatalog.dua(id: id) else { continue }
                seen.insert(id)
                result.append(dua)
            }
        }
        return result
    }
}
