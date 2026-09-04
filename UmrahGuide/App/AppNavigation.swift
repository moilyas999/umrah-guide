import SwiftUI

/// Marketing and build numbers. Keep in lockstep with Xcode `MARKETING_VERSION`
/// and `CURRENT_PROJECT_VERSION`.
enum AppVersion {
    static let marketing = "1.0.1"
    static let build = "4"
}

/// The app is light-only. Dark palettes are not offered.
enum AppearancePolicy {
    static let preferredColorScheme: ColorScheme = .light
    /// Value for `UIUserInterfaceStyle` / `INFOPLIST_KEY_UIUserInterfaceStyle`.
    static let userInterfaceStyle = "Light"
}

/// Primary destinations on the tab bar. Duas is first-class — never only under More.
enum AppTab: String, CaseIterable, Identifiable {
    case perform
    case duas
    case pack
    case more

    var id: String { rawValue }

    var title: String {
        switch self {
        case .perform: return "Perform"
        case .duas: return "Duas"
        case .pack: return "Pack"
        case .more: return "More"
        }
    }

    var systemImage: String {
        switch self {
        case .perform: return "figure.walk"
        case .duas: return "text.book.closed"
        case .pack: return "checklist"
        case .more: return "ellipsis.circle"
        }
    }

    /// Order shown in the tab bar.
    static let primary: [AppTab] = [.perform, .duas, .pack, .more]

    @ViewBuilder
    var rootView: some View {
        switch self {
        case .perform:
            PerformUmrahView()
        case .duas:
            DuasView()
        case .pack:
            ChecklistView()
        case .more:
            MoreView()
        }
    }
}

/// Items on the More tab. Duas is not listed here.
enum MoreItem: String, CaseIterable, Identifiable {
    case about
    case restartPerform

    var id: String { rawValue }

    var title: String {
        switch self {
        case .about: return "About"
        case .restartPerform: return "Start Perform from the beginning"
        }
    }
}
