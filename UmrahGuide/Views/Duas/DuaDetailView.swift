import SwiftUI

struct DuaDetailView: View {
    let dua: Dua

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(dua.occasion.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                    Text(dua.occasion.meaning)
                        .font(.footnote)
                        .foregroundStyle(Theme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Occasion: \(dua.occasion.title). \(dua.occasion.meaning)")

                DuaDisplayFilterBar()

                LabeledSection(title: "Dua") {
                    DuaTextBlock(dua: dua, showsTitle: false)
                }

                LabeledSection(title: "When to say it") {
                    Text(dua.whenToSay)
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                }

                LabeledSection(title: "Source") {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(sourceKindLabel)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.ink)
                        Text(dua.sourceNote)
                            .font(.body)
                            .foregroundStyle(Theme.ink)
                    }
                }
            }
            .padding(.horizontal, Theme.horizontalPadding)
            .padding(.vertical, 12)
        }
        .umrahScreenBackground()
        .navigationTitle(dua.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var sourceKindLabel: String {
        switch dua.sourceKind {
        case .quran:
            return "Qur'an wording"
        case .wellKnownAuthentic:
            return "Well-known authentic wording"
        case .traditionalWording:
            return "Traditional wording — no isnad claimed"
        }
    }
}

#Preview {
    NavigationStack {
        DuaDetailView(dua: DuaCatalog.duas[0])
    }
    .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.dua.detail") ?? .standard))
}
