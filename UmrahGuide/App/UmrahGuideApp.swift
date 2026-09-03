import SwiftUI

@main
struct UmrahGuideApp: App {
    @StateObject private var checklistStore = ChecklistStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(checklistStore)
                .tint(Theme.accent)
        }
    }
}
