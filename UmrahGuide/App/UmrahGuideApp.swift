import SwiftUI

@main
struct UmrahGuideApp: App {
    @StateObject private var checklistStore = ChecklistStore()
    @StateObject private var performStore = PerformStore()
    @StateObject private var duaDisplayStore = DuaDisplayStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(checklistStore)
                .environmentObject(performStore)
                .environmentObject(duaDisplayStore)
                .tint(Theme.accent)
        }
    }
}
