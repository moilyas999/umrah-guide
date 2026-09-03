import SwiftUI

struct PrayThisNowCard: View {
    let dua: Dua
    var showsPronunciation: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Pray this now")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(Theme.page)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Theme.accent)
                .clipShape(Capsule())
                .accessibilityAddTraits(.isHeader)

            Text(dua.title)
                .font(.headline)
                .foregroundStyle(Theme.ink)

            Text(dua.arabic)
                .font(.title.weight(.medium))
                .foregroundStyle(Theme.ink)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .environment(\.layoutDirection, .rightToLeft)
                .textSelection(.enabled)
                .minimumScaleFactor(0.7)

            Text(dua.meaning)
                .font(.title3.weight(.medium))
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)

            if showsPronunciation {
                Text(dua.transliteration)
                    .font(.body)
                    .italic()
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
                    .textSelection(.enabled)
            }
        }
        .umrahCard()
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous)
                .stroke(Theme.accent.opacity(0.45), lineWidth: 2)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Pray this now. \(dua.title). \(dua.meaning)")
    }
}

#Preview {
    ScrollView {
        PrayThisNowCard(dua: DuaCatalog.duas[0], showsPronunciation: true)
            .padding()
    }
    .umrahScreenBackground()
}
