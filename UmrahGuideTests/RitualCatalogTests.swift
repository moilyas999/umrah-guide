import XCTest
@testable import UmrahGuide

final class RitualCatalogTests: XCTestCase {
    func testRequiredRitualStepsExistInOrder() {
        let ids = RitualCatalog.steps.map(\.id)
        XCTAssertEqual(ids, RitualCatalog.requiredIDs)
        XCTAssertEqual(ids, [.ihram, .tawaf, .sai, .halqTaqsir])
    }

    func testEachStepHasGuidanceSections() {
        XCTAssertEqual(RitualCatalog.steps.count, 4)

        for step in RitualCatalog.steps {
            XCTAssertFalse(step.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, "Title missing for \(step.id)")
            XCTAssertFalse(step.whatToDo.isEmpty, "What-to-do missing for \(step.id)")
            XCTAssertFalse(step.commonMistakes.isEmpty, "Common mistakes missing for \(step.id)")
            XCTAssertFalse(step.womenNotes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, "Women notes missing for \(step.id)")
            XCTAssertEqual(step.order, RitualCatalog.steps.firstIndex(where: { $0.id == step.id })! + 1)
        }
    }

    func testStepTitlesMatchProductScope() {
        let titles = RitualCatalog.steps.map(\.title)
        XCTAssertEqual(titles, ["Ihram", "Tawaf", "Sa'i", "Halq or Taqsir"])
    }

    func testWomenNotesMentionTaqsirOnHairStep() {
        let hair = RitualCatalog.step(id: .halqTaqsir)
        XCTAssertTrue(hair.womenNotes.localizedCaseInsensitiveContains("taqsir"))
        XCTAssertTrue(hair.womenNotes.localizedCaseInsensitiveContains("not shaving") || hair.womenNotes.localizedCaseInsensitiveContains("do not shave"))
    }

    func testDuasCoverIhramTawafAndSai() {
        let occasions = Set(DuaCatalog.duas.map(\.occasion))
        XCTAssertEqual(occasions, Set(DuaOccasion.allCases))
        XCTAssertFalse(DuaCatalog.duas.contains(where: { $0.arabic.isEmpty || $0.sourceNote.isEmpty }))
    }
}
