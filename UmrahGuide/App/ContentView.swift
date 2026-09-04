import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ForEach(AppTab.primary) { tab in
                tab.rootView
                    .tabItem {
                        Label(tab.title, systemImage: tab.systemImage)
                    }
            }
        }
        .preferredColorScheme(AppearancePolicy.preferredColorScheme)
    }
}

#Preview {
    ContentView()
        .environmentObject(ChecklistStore(defaults: UserDefaults(suiteName: "preview.checklist") ?? .standard))
        .environmentObject(PerformStore(defaults: UserDefaults(suiteName: "preview.perform") ?? .standard))
        .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.display") ?? .standard))
}
