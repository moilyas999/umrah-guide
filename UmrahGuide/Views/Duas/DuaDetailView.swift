import SwiftUI

struct DuaDetailView: View {
    let dua: Dua

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(dua.title)
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(Theme.ink)
                    .accessibilityAddTraits(.isHeader)

                Text(dua.occasion.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                    .accessibilityLabel("Occasion: \(dua.occasion.title)")

                LabeledSection(title: "Arabic", systemImage: "textformat.alt") {
                    Text(dua.arabic)
                        .font(.title2)
                        .foregroundStyle(Theme.ink)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .environment(\.layoutDirection, .rightToLeft)
                        .textSelection(.enabled)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Arabic. \(dua.transliteration)")

                LabeledSection(title: "Transliteration", systemImage: "character.book.closed") {
                    Text(dua.transliteration)
                        .font(.body)
                        .italic()
                        .foregroundStyle(Theme.ink)
                        .textSelection(.enabled)
                }

                LabeledSection(title: "Meaning", systemImage: "quote.closing") {
                    Text(dua.meaning)
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                }

                LabeledSection(title: "When to say it", systemImage: "clock") {
                    Text(dua.whenToSay)
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                }

                LabeledSection(title: "Source note", systemImage: "scroll") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(sourceKindLabel)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.accent)
                        Text(dua.sourceNote)
                            .font(.body)
                            .foregroundStyle(Theme.ink)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
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
}
