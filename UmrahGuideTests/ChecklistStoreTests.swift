import XCTest
@testable import UmrahGuide

final class ChecklistStoreTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!
    private let key = "tests.checklist.checkedIDs"

    override func setUpWithError() throws {
        try super.setUpWithError()
        suiteName = "ai.desklink.umrahguide.tests.\(UUID().uuidString)"
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

    func testTogglePersistsAcrossRelaunch() {
        let first = ChecklistStore(defaults: defaults, storageKey: key)
        XCTAssertFalse(first.isChecked("ihram.pins"))

        first.toggle("ihram.pins")
        XCTAssertTrue(first.isChecked("ihram.pins"))

        let second = ChecklistStore(defaults: defaults, storageKey: key)
        XCTAssertTrue(second.isChecked("ihram.pins"), "Checked IDs must reload from UserDefaults")
        XCTAssertEqual(second.checkedIDs, ["ihram.pins"])
    }

    func testResetClearsPersistedState() {
        let store = ChecklistStore(defaults: defaults, storageKey: key)
        store.toggle("pack.passport")
        store.toggle("ihram.sandals")
        XCTAssertEqual(store.checkedCount(in: ChecklistCatalog.items), 2)

        store.reset()
        XCTAssertTrue(store.checkedIDs.isEmpty)

        let reloaded = ChecklistStore(defaults: defaults, storageKey: key)
        XCTAssertTrue(reloaded.checkedIDs.isEmpty)
    }

    func testSetCheckedIsIdempotent() {
        let store = ChecklistStore(defaults: defaults, storageKey: key)
        store.setChecked("pack.water", isChecked: true)
        store.setChecked("pack.water", isChecked: true)
        XCTAssertEqual(store.checkedIDs, ["pack.water"])

        store.setChecked("pack.water", isChecked: false)
        XCTAssertFalse(store.isChecked("pack.water"))
    }

    func testCatalogIdentifiersAreUnique() {
        let ids = ChecklistCatalog.items.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count)
        XCTAssertFalse(ids.isEmpty)
    }
}
