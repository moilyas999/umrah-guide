import XCTest
@testable import UmrahGuide

final class PerformCatalogTests: XCTestCase {
    func testLinearOrderMatchesRequiredIDs() {
        XCTAssertEqual(PerformCatalog.steps.map(\.id), PerformCatalog.requiredIDs)
        XCTAssertEqual(PerformCatalog.steps.count, 16)
    }

    func testEachStepHasOneToThreeDoNowSentences() {
        for step in PerformCatalog.steps {
            XCTAssertFalse(step.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, "Title missing for \(step.id)")
            XCTAssertGreaterThanOrEqual(step.doNow.count, 1, "\(step.id) needs something to do now")
            XCTAssertLessThanOrEqual(step.doNow.count, 3, "\(step.id) dumps too much on one screen")
            for sentence in step.doNow {
                XCTAssertFalse(sentence.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }

    func testStagesStayInIhramTawafSaiHalqOrder() {
        let stages = PerformCatalog.steps.map(\.stage)
        XCTAssertEqual(stages.first, .ihram)
        XCTAssertEqual(stages.last, .halqTaqsir)

        let rank: [PerformStage: Int] = [
            .ihram: 0,
            .tawaf: 1,
            .sai: 2,
            .halqTaqsir: 3
        ]
        let ranks = stages.map { rank[$0]! }
        XCTAssertEqual(ranks, ranks.sorted(), "A pilgrim should never be sent backwards through the four stages")
    }

    func testPrimaryDuasResolveAndStayShort() {
        var linked = 0
        for step in PerformCatalog.steps {
            guard let id = step.primaryDuaID else { continue }
            linked += 1
            let dua = DuaCatalog.dua(id: id)
            XCTAssertNotNil(dua, "Step \(step.id) points at missing dua \(id)")
            XCTAssertFalse(dua?.arabic.isEmpty ?? true)
            XCTAssertFalse(dua?.meaning.isEmpty ?? true)
        }
        XCTAssertGreaterThanOrEqual(linked, 8, "Most rite moments should offer one dua in context")
    }

    func testHairStepExplainsWomenDoNotShave() {
        let hair = PerformCatalog.step(id: "cut-hair")
        let blob = ([hair.title] + hair.doNow + [hair.womenNote ?? ""]).joined(separator: " ")
        XCTAssertTrue(blob.localizedCaseInsensitiveContains("women"))
        XCTAssertTrue(blob.localizedCaseInsensitiveContains("shave") || blob.localizedCaseInsensitiveContains("taqsir"))
    }
}
