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
                VStack(alignment: .leading, spacing: 24) {
                    ScreenHeader(
                        title: "Duas",
                        subtitle: "Tap a title to open that dua. Use the filter to show Arabic, how to say it, and meaning in any combination."
                    )

                    DuaDisplayFilterBar()

                    DisclaimerBanner(compact: true)

                    ForEach(DuaOccasion.allCases) { occasion in
                        VStack(alignment: .leading, spacing: 10) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(occasion.title)
                                    .font(.title3.weight(.bold))
                                    .foregroundStyle(Theme.accent)
                                    .accessibilityAddTraits(.isHeader)
                                Text(occasion.meaning)
                                    .font(.body)
                                    .foregroundStyle(Theme.muted)
                                    .fixedSize(horizontal: false, vertical: true)
                            }

                            ForEach(DuaCatalog.duas(for: occasion)) { dua in
                                CollapsibleDuaRow(dua: dua, showsDetailLink: true, style: .card)
                            }
                        }
                        .id(occasion)
                    }
                }
                .padding(.horizontal, Theme.horizontalPadding)
                .padding(.vertical, 16)
            }
            .umrahScreenBackground()
            .navigationTitle("Duas")
            .navigationBarTitleDisplayMode(.inline)
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
}

#Preview {
    DuasView()
        .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.duas") ?? .standard))
}
