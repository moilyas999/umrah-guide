import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PerformUmrahView()
                .tabItem {
                    Label("Perform Umrah", systemImage: "figure.walk")
                }

            ChecklistView()
                .tabItem {
                    Label("Checklist", systemImage: "checklist")
                }

            DuasView()
                .tabItem {
                    Label("Duas", systemImage: "text.book.closed")
                }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ChecklistStore(defaults: UserDefaults(suiteName: "preview.checklist") ?? .standard))
}
