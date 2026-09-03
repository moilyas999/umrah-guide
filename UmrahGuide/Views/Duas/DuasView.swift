import SwiftUI

struct DuasView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ScreenHeader(
                        title: "Duas",
                        subtitle: "Well-known wording for Ihram, Tawaf, and Sa'i. Source notes stay honest: no invented hadith numbers."
                    )

                    DisclaimerBanner(compact: true)

                    ForEach(DuaOccasion.allCases) { occasion in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(occasion.title)
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(Theme.accent)
                                .accessibilityAddTraits(.isHeader)

                            ForEach(DuaCatalog.duas(for: occasion)) { dua in
                                NavigationLink(value: dua.id) {
                                    DuaRow(dua: dua)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .umrahScreenBackground()
            .navigationTitle("Duas")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: String.self) { id in
                if let dua = DuaCatalog.duas.first(where: { $0.id == id }) {
                    DuaDetailView(dua: dua)
                }
            }
        }
    }
}

private struct DuaRow: View {
    let dua: Dua

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(dua.title)
                .font(.headline)
                .foregroundStyle(Theme.ink)
            Text(dua.arabic)
                .font(.title3)
                .foregroundStyle(Theme.ink)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .environment(\.layoutDirection, .rightToLeft)
            Text(dua.transliteration)
                .font(.subheadline)
                .italic()
                .foregroundStyle(Theme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .umrahCard()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(dua.title). \(dua.transliteration). \(dua.meaning)")
        .accessibilityHint("Opens the full dua with the source note")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    DuasView()
}
