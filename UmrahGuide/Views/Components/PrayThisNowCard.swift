import SwiftUI

struct PrayThisNowCard: View {
    let dua: Dua

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pray this now")
                .font(.caption.weight(.bold))
                .foregroundStyle(Theme.page)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Theme.accent)
                .clipShape(Capsule())
                .accessibilityAddTraits(.isHeader)

            DuaTextBlock(dua: dua)
        }
        .umrahCard()
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous)
                .stroke(Theme.accent.opacity(0.28), lineWidth: 1.5)
        )
    }
}

#Preview {
    ScrollView {
        PrayThisNowCard(dua: DuaCatalog.duas[0])
            .padding()
    }
    .umrahScreenBackground()
    .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.pray") ?? .standard))
}
