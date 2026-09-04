import SwiftUI

struct PrayThisNowCard: View {
    let dua: Dua

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Pray this now")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.accent)
                .accessibilityAddTraits(.isHeader)

            DuaTextBlock(dua: dua)
        }
        .umrahCard()
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
