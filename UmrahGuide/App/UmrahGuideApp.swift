import SwiftUI

@main
struct UmrahGuideApp: App {
    @StateObject private var checklistStore = ChecklistStore()
    @StateObject private var performStore = PerformStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(checklistStore)
                .environmentObject(performStore)
                .tint(Theme.accent)
        }
    }
}
