import XCTest
@testable import UmrahGuide

final class DuaExpansionTests: XCTestCase {
    func testDefaultIsEveryDuaBodyCollapsed() {
        let duas = DuaCatalog.duas
        XCTAssertEqual(DuaExpansion.defaultExpandedIDs(for: duas), [])
        XCTAssertTrue(DuaExpansion.defaultExpandedIDs().isEmpty)

        let rows = DuaExpansion.presentations(
            duas: duas,
            expandedIDs: DuaExpansion.defaultExpandedIDs(for: duas),
            options: .default
        )
        XCTAssertEqual(rows.count, duas.count)
        XCTAssertTrue(rows.allSatisfy { !$0.isExpanded })
    }

    func testCollapsedRowShowsTitleAndLabelWithoutBodyText() {
        let talbiyah = try! XCTUnwrap(DuaCatalog.dua(id: "talbiyah"))
        XCTAssertEqual(DuaExpansion.collapsedTitle(for: talbiyah), "Dua for Talbiyah")
        XCTAssertEqual(DuaExpansion.collapsedLabel(for: talbiyah), DuaOccasion.ihram.title)
        XCTAssertFalse(DuaExpansion.collapsedTitle(for: talbiyah).contains(talbiyah.arabic))
        XCTAssertFalse(DuaExpansion.collapsedTitle(for: talbiyah).contains(talbiyah.transliteration))
        XCTAssertFalse(DuaExpansion.collapsedTitle(for: talbiyah).contains(talbiyah.meaning))
    }

    func testToggleOpensThenClosesOnlyThatDua() {
        let start = DuaExpansion.defaultExpandedIDs()
        let opened = DuaExpansion.toggle("talbiyah", in: start)
        XCTAssertEqual(opened, ["talbiyah"])

        let alsoRabbana = DuaExpansion.toggle("tawaf.rabbana", in: opened)
        XCTAssertEqual(alsoRabbana, ["talbiyah", "tawaf.rabbana"])

        let closedTalbiyah = DuaExpansion.toggle("talbiyah", in: alsoRabbana)
        XCTAssertEqual(closedTalbiyah, ["tawaf.rabbana"])
    }

    func testDefaultFilterShowsArabicTransliterationAndMeaningWhenExpanded() {
        let dua = try! XCTUnwrap(DuaCatalog.dua(id: "tawaf.rabbana"))
        let body = DuaExpansion.visibleBody(for: dua, options: .default)
        XCTAssertEqual(body.arabic, dua.arabic)
        XCTAssertEqual(body.transliteration, dua.transliteration)
        XCTAssertEqual(body.meaning, dua.meaning)
        XCTAssertTrue(dua.transliteration.localizedCaseInsensitiveContains("atina"))

        let rows = DuaExpansion.presentations(
            duas: [dua],
            expandedIDs: ["tawaf.rabbana"],
            options: .default
        )
        XCTAssertEqual(rows[0].visibleArabic, dua.arabic)
        XCTAssertEqual(rows[0].visibleTransliteration, dua.transliteration)
        XCTAssertEqual(rows[0].visibleMeaning, dua.meaning)
        XCTAssertTrue(rows[0].showsAnyBodyText)
    }

    func testFiltersHideBodyFieldsIndependently() {
        let dua = try! XCTUnwrap(DuaCatalog.dua(id: "haram.enter"))

        let sayItOnly = DuaDisplayOptions(
            showsArabic: false,
            showsTransliteration: true,
            showsMeaning: false
        )
        let sayIt = DuaExpansion.visibleBody(for: dua, options: sayItOnly)
        XCTAssertNil(sayIt.arabic)
        XCTAssertEqual(sayIt.transliteration, dua.transliteration)
        XCTAssertNil(sayIt.meaning)
        XCTAssertTrue(dua.transliteration.localizedCaseInsensitiveContains("iftah"))

        let arabicMeaning = DuaDisplayOptions(
            showsArabic: true,
            showsTransliteration: false,
            showsMeaning: true
        )
        let rows = DuaExpansion.presentations(
            duas: [dua],
            expandedIDs: [dua.id],
            options: arabicMeaning
        )
        XCTAssertEqual(rows[0].visibleArabic, dua.arabic)
        XCTAssertNil(rows[0].visibleTransliteration)
        XCTAssertEqual(rows[0].visibleMeaning, dua.meaning)

        let none = DuaDisplayOptions(
            showsArabic: false,
            showsTransliteration: false,
            showsMeaning: false
        )
        let empty = DuaExpansion.presentations(
            duas: [dua],
            expandedIDs: [dua.id],
            options: none
        )
        XCTAssertFalse(empty[0].showsAnyBodyText)
    }

    func testDuasTabGroupsByOccasionAndStartsCollapsed() {
        for occasion in DuaOccasion.allCases {
            let duas = DuaCatalog.duas(for: occasion)
            XCTAssertFalse(duas.isEmpty, "Missing duas for \(occasion.rawValue)")
            let rows = DuaExpansion.presentations(
                duas: duas,
                expandedIDs: DuaExpansion.defaultExpandedIDs(for: duas),
                options: .default
            )
            XCTAssertTrue(rows.allSatisfy { !$0.isExpanded })
            XCTAssertTrue(rows.allSatisfy { $0.label == occasion.title })
        }
    }

    func testPerformStepListsOnlyThatStepsDuasAndTheyStartCollapsed() {
        let intend = PerformCatalog.step(id: "intend")
        let duas = DuaExpansion.duas(for: intend)
        XCTAssertEqual(duas.map(\.id), ["talbiyah", "ihram.labbayk.umrah"])

        let rows = DuaExpansion.presentations(
            duas: duas,
            expandedIDs: DuaExpansion.defaultExpandedIDs(for: duas),
            options: .default
        )
        XCTAssertEqual(rows.count, 2)
        XCTAssertTrue(rows.allSatisfy { !$0.isExpanded })
        XCTAssertTrue(rows.allSatisfy { $0.visibleTransliteration?.isEmpty == false })

        let wash = PerformCatalog.step(id: "wash")
        XCTAssertTrue(DuaExpansion.duas(for: wash).isEmpty)

        let tawafStart = PerformCatalog.step(id: "enter-haram")
        XCTAssertEqual(DuaExpansion.duas(for: tawafStart).map(\.id), ["haram.enter"])
    }

    func testPersistedFilterIsAppliedToExpandedBody() {
        let suite = "ai.desklink.umrahguide.tests.expansion.\(UUID().uuidString)"
        let defaults = try! XCTUnwrap(UserDefaults(suiteName: suite))
        defaults.removePersistentDomain(forName: suite)
        defer { defaults.removePersistentDomain(forName: suite) }

        let key = "tests.display.duaFields"
        let store = DuaDisplayStore(defaults: defaults, storageKey: key)
        store.set(.arabic, isOn: false)
        store.set(.meaning, isOn: false)
        XCTAssertTrue(store.options.showsTransliteration)

        let reloaded = DuaDisplayStore(defaults: defaults, storageKey: key)
        XCTAssertEqual(reloaded.options, store.options)

        let dua = try! XCTUnwrap(DuaCatalog.dua(id: "talbiyah"))
        let body = DuaExpansion.visibleBody(for: dua, options: reloaded.options)
        XCTAssertNil(body.arabic)
        XCTAssertEqual(body.transliteration, dua.transliteration)
        XCTAssertNil(body.meaning)
    }
}
