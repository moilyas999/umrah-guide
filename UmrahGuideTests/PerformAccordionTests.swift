import XCTest
@testable import UmrahGuide

final class PerformAccordionTests: XCTestCase {
    func testDefaultExpandedIsOnlyTheCurrentStage() {
        XCTAssertEqual(PerformAccordion.defaultExpanded(for: .tawaf), [.tawaf])
        XCTAssertEqual(PerformAccordion.defaultExpanded(for: .ihram).count, 1)
    }

    func testToggleExpandsAndCollapses() {
        let start: Set<PerformStage> = [.ihram]
        let opened = PerformAccordion.toggle(.sai, in: start)
        XCTAssertEqual(opened, [.ihram, .sai])
        let closed = PerformAccordion.toggle(.ihram, in: opened)
        XCTAssertEqual(closed, [.sai])
    }

    func testMovingIntoAStageAlwaysExpandsIt() {
        let collapsed: Set<PerformStage> = []
        let next = PerformAccordion.afterMoving(to: .tawaf, expanded: collapsed)
        XCTAssertTrue(next.contains(.tawaf))

        let kept = PerformAccordion.afterMoving(to: .sai, expanded: [.ihram])
        XCTAssertEqual(kept, [.ihram, .sai])
    }

    func testPresentationsAreFourStagesWithCurrentMarked() {
        let rows = PerformAccordion.presentations(
            stepIndex: 0,
            doneIDs: [],
            expandedStages: [.ihram]
        )
        XCTAssertEqual(rows.map(\.stage), PerformStage.allCases)
        XCTAssertTrue(rows[0].isCurrent)
        XCTAssertTrue(rows[0].isExpanded)
        XCTAssertFalse(rows[1].isCurrent)
        XCTAssertFalse(rows[1].isExpanded)
        XCTAssertEqual(rows[0].stepNumber, 1)
        XCTAssertEqual(rows[0].actionSummary, PerformCatalog.step(id: "wash").actionSummary)
        XCTAssertEqual(rows[0].totalCount, PerformCatalog.steps(in: .ihram).count)
    }

    func testCurrentStageUsesTheLiveStepForProgressAndSummary() {
        let intendIndex = PerformCatalog.steps.firstIndex(where: { $0.id == "intend" })!
        let rows = PerformAccordion.presentations(
            stepIndex: intendIndex,
            doneIDs: ["wash", "dress"],
            expandedStages: [.ihram]
        )
        let ihram = rows.first { $0.stage == .ihram }
        XCTAssertEqual(ihram?.isCurrent, true)
        XCTAssertEqual(ihram?.stepNumber, 4)
        XCTAssertEqual(ihram?.completedCount, 2)
        XCTAssertEqual(ihram?.actionSummary, PerformCatalog.step(id: "intend").actionSummary)
        XCTAssertTrue(ihram?.duas.contains(where: { $0.id == "talbiyah" }) ?? false)
    }

    func testAdvancingIntoTawafMarksTawafCurrentAndCanExpandIt() {
        let enterIndex = PerformCatalog.steps.firstIndex(where: { $0.id == "enter-haram" })!
        var expanded = PerformAccordion.defaultExpanded(for: .ihram)
        expanded = PerformAccordion.afterMoving(to: .tawaf, expanded: expanded)

        let rows = PerformAccordion.presentations(
            stepIndex: enterIndex,
            doneIDs: [],
            expandedStages: expanded
        )
        let tawaf = try! XCTUnwrap(rows.first { $0.stage == .tawaf })
        XCTAssertTrue(tawaf.isCurrent)
        XCTAssertTrue(tawaf.isExpanded)
        XCTAssertEqual(tawaf.stepNumber, 1)
        XCTAssertEqual(tawaf.actionSummary, PerformCatalog.step(id: "enter-haram").actionSummary)
        XCTAssertFalse(rows.first { $0.stage == .ihram }?.isCurrent ?? true)
    }

    func testUpcomingStageUsesFirstUndoneActionSummary() {
        let rows = PerformAccordion.presentations(
            stepIndex: 0,
            doneIDs: [],
            expandedStages: [.ihram]
        )
        let sai = try! XCTUnwrap(rows.first { $0.stage == .sai })
        XCTAssertFalse(sai.isCurrent)
        XCTAssertEqual(sai.stepNumber, 1)
        XCTAssertEqual(sai.actionSummary, PerformCatalog.step(id: "start-sai").actionSummary)
    }

    func testStageDuasAreUniqueAndBoundToThatStage() {
        let rows = PerformAccordion.presentations(
            stepIndex: 0,
            doneIDs: [],
            expandedStages: PerformStage.allCases.reduce(into: Set()) { $0.insert($1) }
        )
        let tawaf = try! XCTUnwrap(rows.first { $0.stage == .tawaf })
        let ids = tawaf.duas.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count)
        XCTAssertTrue(ids.contains("tawaf.rabbana"))
        XCTAssertTrue(ids.contains("haram.enter"))
        XCTAssertFalse(ids.contains("talbiyah"))
        XCTAssertFalse(ids.contains("sai.safa.verse"))
    }

    func testStepDuaRowsDefaultCollapsedAndDoNotDumpTheWholeStage() {
        let tawafStart = PerformCatalog.step(id: "enter-haram")
        let stepDuas = DuaExpansion.duas(for: tawafStart)
        XCTAssertEqual(stepDuas.map(\.id), ["haram.enter"])

        let rows = DuaExpansion.presentations(
            duas: stepDuas,
            expandedIDs: DuaExpansion.defaultExpandedIDs(for: stepDuas),
            options: .default
        )
        XCTAssertEqual(rows.count, 1)
        XCTAssertFalse(rows[0].isExpanded)
        XCTAssertEqual(rows[0].title, "Dua for Entering a mosque")
        XCTAssertEqual(rows[0].visibleTransliteration, stepDuas[0].transliteration)
    }
}
