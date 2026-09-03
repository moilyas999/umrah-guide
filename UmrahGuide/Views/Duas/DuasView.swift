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
                        subtitle: "Short, well-known wording. Arabic and English meaning on every card. Nothing here is required on every lap or every leg."
                    )

                    DisclaimerBanner(compact: true)

                    ForEach(DuaOccasion.allCases) { occasion in
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(occasion.title)
                                    .font(.title2.weight(.bold))
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
                .padding(.horizontal, 20)
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
        VStack(alignment: .leading, spacing: 12) {
            Text(dua.title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Theme.ink)

            Text(dua.arabic)
                .font(.title2.weight(.medium))
                .foregroundStyle(Theme.ink)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .environment(\.layoutDirection, .rightToLeft)
                .minimumScaleFactor(0.7)

            Text(dua.meaning)
                .font(.title3)
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .umrahCard()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(dua.title). \(dua.meaning)")
        .accessibilityHint("Opens the full dua with pronunciation and the source note")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    DuasView()
}
