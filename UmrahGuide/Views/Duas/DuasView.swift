import SwiftUI

struct DuasView: View {
    var initialOccasion: DuaOccasion?
    var embedsNavigation: Bool = true

    var body: some View {
        if embedsNavigation {
            NavigationStack {
                list
            }
        } else {
            list
        }
    }

    private var list: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ScreenLead(subtitle: "Tap a title to open it. Filter Arabic, how to say it, and meaning.")

                    DuaDisplayFilterBar()

                    if DuaCatalog.duas.isEmpty {
                        EmptyState(
                            title: "No duas yet",
                            message: "This list is empty on this device."
                        )
                    } else {
                        ForEach(DuaOccasion.allCases) { occasion in
                            occasionSection(occasion)
                                .id(occasion)
                        }
                    }
                }
                .padding(.horizontal, Theme.horizontalPadding)
                .padding(.vertical, 12)
            }
            .umrahScreenBackground()
            .navigationTitle("Duas")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                if let initialOccasion {
                    DispatchQueue.main.async {
                        withAnimation {
                            proxy.scrollTo(initialOccasion, anchor: .top)
                        }
                    }
                }
            }
        }
    }

    private func occasionSection(_ occasion: DuaOccasion) -> some View {
        let duas = DuaCatalog.duas(for: occasion)
        return VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(occasion.title)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                    .accessibilityAddTraits(.isHeader)
                Text(occasion.meaning)
                    .font(.footnote)
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if duas.isEmpty {
                EmptyState(title: "None here", message: "No duas in this group.")
            } else {
                ForEach(duas) { dua in
                    CollapsibleDuaRow(dua: dua, showsDetailLink: true, style: .card)
                }
            }
        }
    }
}

#Preview {
    DuasView()
        .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.duas") ?? .standard))
}
