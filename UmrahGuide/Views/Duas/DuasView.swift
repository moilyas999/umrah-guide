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
                        subtitle: "Short, well-known wording. Use the filter to show Arabic, how to say it, and meaning in any combination."
                    )

                    DuaDisplayFilterBar()

                    DisclaimerBanner(compact: true)

                    ForEach(DuaOccasion.allCases) { occasion in
                        VStack(alignment: .leading, spacing: 12) {
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
                                NavigationLink(value: dua.id) {
                                    DuaRow(dua: dua)
                                }
                                .buttonStyle(.plain)
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
            .navigationDestination(for: String.self) { id in
                if let dua = DuaCatalog.dua(id: id) {
                    DuaDetailView(dua: dua)
                }
            }
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

private struct DuaRow: View {
    let dua: Dua

    var body: some View {
        DuaTextBlock(dua: dua, compact: true)
            .umrahCard()
            .accessibilityHint("Opens the full dua with the source note")
            .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    DuasView()
        .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.duas") ?? .standard))
}
