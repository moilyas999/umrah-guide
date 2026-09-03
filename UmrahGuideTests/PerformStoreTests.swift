import XCTest
@testable import UmrahGuide

final class PerformStoreTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!
    private let indexKey = "tests.perform.stepIndex"
    private let doneKey = "tests.perform.doneIDs"

    override func setUpWithError() throws {
        try super.setUpWithError()
        suiteName = "ai.desklink.umrahguide.tests.perform.\(UUID().uuidString)"
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

    private func makeStore() -> PerformStore {
        PerformStore(defaults: defaults, indexKey: indexKey, doneKey: doneKey)
    }

    func testIndexPersistsAcrossRelaunch() {
        let first = makeStore()
        XCTAssertEqual(first.stepIndex, 0)
        first.advance()
        first.advance()
        XCTAssertEqual(first.stepIndex, 2)
        XCTAssertEqual(first.currentStep.id, PerformCatalog.steps[2].id)

        let second = makeStore()
        XCTAssertEqual(second.stepIndex, 2, "Place in Perform must reload from UserDefaults")
        XCTAssertEqual(second.currentStep.id, first.currentStep.id)
    }

    func testDoneTicksPersistAndToggle() {
        let first = makeStore()
        first.toggleDone("intend")
        XCTAssertTrue(first.isDone("intend"))

        let second = makeStore()
        XCTAssertTrue(second.isDone("intend"))
        second.toggleDone("intend")
        XCTAssertFalse(second.isDone("intend"))
    }

    func testJumpToStageLandsOnFirstStepOfThatStage() {
        let store = makeStore()
        store.jumpToStage(.sai)
        XCTAssertEqual(store.currentStep.stage, .sai)
        XCTAssertEqual(store.currentStep.id, "start-sai")
        store.jumpToStage(.ihram)
        XCTAssertEqual(store.currentStep.id, "wash")
    }

    func testIndexIsClamped() {
        let store = makeStore()
        store.goTo(index: 99)
        XCTAssertEqual(store.stepIndex, PerformCatalog.steps.count - 1)
        store.goTo(index: -4)
        XCTAssertEqual(store.stepIndex, 0)
    }

    func testResetClearsPlaceAndTicks() {
        let store = makeStore()
        store.goTo(index: 5)
        store.setDone("wash", isDone: true)
        store.reset()
        XCTAssertEqual(store.stepIndex, 0)
        XCTAssertTrue(store.doneIDs.isEmpty)

        let reloaded = makeStore()
        XCTAssertEqual(reloaded.stepIndex, 0)
        XCTAssertTrue(reloaded.doneIDs.isEmpty)
    }
}
