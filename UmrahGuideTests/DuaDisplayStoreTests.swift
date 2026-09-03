import XCTest
@testable import UmrahGuide

final class DuaDisplayStoreTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!
    private let key = "tests.display.duaFields"

    override func setUpWithError() throws {
        try super.setUpWithError()
        suiteName = "ai.desklink.umrahguide.tests.display.\(UUID().uuidString)"
        defaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        defaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDownWithError() throws {
        if let suiteName {
            defaults?.removePersistentDomain(forName: suiteName)
        }
        defaults = nil
        suiteName = nil
        try super.tearDownWithError()
    }

    private func makeStore() -> DuaDisplayStore {
        DuaDisplayStore(defaults: defaults, storageKey: key)
    }

    func testDefaultShowsAllThreeFields() {
        let store = makeStore()
        XCTAssertEqual(store.options, .default)
        XCTAssertTrue(store.options.showsArabic)
        XCTAssertTrue(store.options.showsTransliteration)
        XCTAssertTrue(store.options.showsMeaning)
    }

    func testAnyCombinationPersistsAcrossRelaunch() {
        let first = makeStore()
        first.toggle(.transliteration)
        first.toggle(.meaning)
        XCTAssertTrue(first.options.showsArabic)
        XCTAssertFalse(first.options.showsTransliteration)
        XCTAssertFalse(first.options.showsMeaning)

        let second = makeStore()
        XCTAssertEqual(second.options, first.options)
        XCTAssertTrue(second.options.showsArabic)
        XCTAssertFalse(second.options.showsTransliteration)
        XCTAssertFalse(second.options.showsMeaning)
    }

    func testMissingKeyLoadsDefaultAllOn() {
        XCTAssertNil(defaults.data(forKey: key))
        let loaded = DuaDisplayStore.load(from: defaults, key: key)
        XCTAssertEqual(loaded, .default)
    }

    func testTogglingAllowsEmptyCombination() {
        let store = makeStore()
        for field in DuaDisplayField.allCases {
            store.set(field, isOn: false)
        }
        XCTAssertFalse(store.options.showsAnyText)

        let reloaded = makeStore()
        XCTAssertFalse(reloaded.options.showsAnyText)
    }

    func testReplaceAndReset() {
        let store = makeStore()
        store.replace(DuaDisplayOptions(showsArabic: false, showsTransliteration: true, showsMeaning: false))
        XCTAssertEqual(store.options.shows(.transliteration), true)
        XCTAssertEqual(store.options.shows(.arabic), false)

        store.resetToDefault()
        XCTAssertEqual(store.options, .default)

        let reloaded = makeStore()
        XCTAssertEqual(reloaded.options, .default)
    }

    func testOptionsTogglingIsValueTyped() {
        let start = DuaDisplayOptions.default
        let hiddenArabic = start.toggling(.arabic)
        XCTAssertFalse(hiddenArabic.showsArabic)
        XCTAssertTrue(start.showsArabic)
        XCTAssertTrue(hiddenArabic.showsTransliteration)
        XCTAssertTrue(hiddenArabic.showsMeaning)
    }
}
