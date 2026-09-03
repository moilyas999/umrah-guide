import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PerformUmrahView()
                .tabItem {
                    Label("Perform", systemImage: "figure.walk")
                }

            ChecklistView()
                .tabItem {
                    Label("Pack", systemImage: "checklist")
                }

            MoreView()
                .tabItem {
                    Label("More", systemImage: "ellipsis.circle")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ChecklistStore(defaults: UserDefaults(suiteName: "preview.checklist") ?? .standard))
        .environmentObject(PerformStore(defaults: UserDefaults(suiteName: "preview.perform") ?? .standard))
        .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.display") ?? .standard))
}
