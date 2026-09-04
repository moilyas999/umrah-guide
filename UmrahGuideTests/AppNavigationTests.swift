import XCTest
import SwiftUI
@testable import UmrahGuide

final class AppNavigationTests: XCTestCase {
    func testTabBarShowsPerformDuasPackAndMoreInThatOrder() {
        XCTAssertEqual(AppTab.primary.map(\.title), ["Perform", "Duas", "Pack", "More"])
        XCTAssertEqual(AppTab.primary, [.perform, .duas, .pack, .more])
        XCTAssertTrue(AppTab.primary.contains(.duas))
        XCTAssertEqual(AppTab.duas.title, "Duas")
        XCTAssertEqual(Set(AppTab.primary.map(\.title)).count, AppTab.primary.count)
        XCTAssertTrue(AppTab.primary.allSatisfy { $0.title.count <= 8 })
    }

    func testDuasIsNotBuriedUnderMore() {
        XCTAssertFalse(MoreItem.allCases.contains(where: { $0.title.localizedCaseInsensitiveContains("dua") }))
        XCTAssertEqual(MoreItem.allCases, [.about, .restartPerform])
        XCTAssertTrue(MoreItem.allCases.map(\.title).contains("About"))
    }

    func testAppearanceIsForcedLight() {
        XCTAssertEqual(AppearancePolicy.preferredColorScheme, .light)
        XCTAssertEqual(AppearancePolicy.userInterfaceStyle, "Light")
    }

    func testVersionIsOneZeroOneBuildFour() {
        XCTAssertEqual(AppVersion.marketing, "1.0.1")
        XCTAssertEqual(AppVersion.build, "4")
        XCTAssertEqual(AppCopy.bundleID, "ai.desklink.umrahguide")

        let short = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
        if let short {
            XCTAssertEqual(short, AppVersion.marketing)
        }
        if let build {
            XCTAssertEqual(build, AppVersion.build)
        }
    }

    func testPersonalEverydayDuasStayOnTheDuasTabCatalog() {
        XCTAssertEqual(DuaOccasion.personal.title, "Personal / Everyday")
        XCTAssertFalse(DuaCatalog.duas(for: .personal).isEmpty)
        let rows = DuaExpansion.presentations(
            duas: DuaCatalog.duas(for: .personal),
            expandedIDs: DuaExpansion.defaultExpandedIDs(),
            options: .default
        )
        XCTAssertTrue(rows.allSatisfy { !$0.isExpanded })
        XCTAssertTrue(DuaDisplayField.allCases.map(\.rawValue).contains("arabic"))
        XCTAssertTrue(DuaDisplayField.allCases.map(\.rawValue).contains("transliteration"))
        XCTAssertTrue(DuaDisplayField.allCases.map(\.rawValue).contains("meaning"))
    }
}
