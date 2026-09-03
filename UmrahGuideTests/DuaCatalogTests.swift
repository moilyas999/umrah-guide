import XCTest
@testable import UmrahGuide

final class DuaCatalogTests: XCTestCase {
    func testEveryOccasionHasAtLeastOneDua() {
        for occasion in DuaOccasion.allCases {
            XCTAssertFalse(
                DuaCatalog.duas(for: occasion).isEmpty,
                "Missing duas for \(occasion.rawValue)"
            )
        }
    }

    func testRequiredDuasExistWithArabicAndMeaning() {
        for id in DuaCatalog.requiredIDs {
            let dua = DuaCatalog.dua(id: id)
            XCTAssertNotNil(dua, "Missing required dua \(id)")
            XCTAssertFalse(dua?.arabic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            XCTAssertFalse(dua?.meaning.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
            XCTAssertFalse(dua?.sourceNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        }
    }

    func testRabbanaAtinaIsQuranAndTiedToTawaf() {
        let dua = DuaCatalog.dua(id: "tawaf.rabbana")
        XCTAssertEqual(dua?.occasion, .tawaf)
        XCTAssertEqual(dua?.sourceKind, .quran)
        XCTAssertTrue(dua?.sourceNote.contains("2:201") ?? false)
        XCTAssertTrue(dua?.arabic.contains("رَبَّنَا") ?? false)
    }

    func testTalbiyahAndMosqueEntryAreAuthenticWording() {
        XCTAssertEqual(DuaCatalog.dua(id: "talbiyah")?.sourceKind, .wellKnownAuthentic)
        XCTAssertEqual(DuaCatalog.dua(id: "haram.enter")?.sourceKind, .wellKnownAuthentic)
        XCTAssertEqual(DuaCatalog.dua(id: "general.parents")?.sourceKind, .quran)
        XCTAssertEqual(DuaCatalog.dua(id: "general.ummah")?.sourceKind, .quran)
        XCTAssertEqual(DuaCatalog.dua(id: "general.ease")?.sourceKind, .wellKnownAuthentic)
    }

    func testIdentifiersAreUnique() {
        let ids = DuaCatalog.duas.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count)
    }

    func testFirstSightNoteDoesNotInventARequiredScript() {
        let dua = DuaCatalog.dua(id: "kaaba.accept")
        XCTAssertEqual(dua?.occasion, .firstSightKaaba)
        let note = (dua?.whenToSay ?? "") + (dua?.sourceNote ?? "")
        XCTAssertTrue(note.localizedCaseInsensitiveContains("no required"))
    }
}
