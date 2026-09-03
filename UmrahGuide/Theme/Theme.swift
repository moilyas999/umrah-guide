import SwiftUI

enum Theme {
    static let accent = Color("AccentGreen")
    static let gold = Color("WarmGold")
    static let page = Color("PageBackground")
    static let card = Color("CardBackground")
    static let ink = Color("Ink")
    static let muted = Color("MutedInk")
    static let danger = Color("Caution")

    static let cardRadius: CGFloat = 16
}

extension View {
    func umrahCard() -> some View {
        self
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous)
                    .stroke(Theme.ink.opacity(0.08), lineWidth: 1)
            )
    }

    func umrahScreenBackground() -> some View {
        self.background(Theme.page.ignoresSafeArea())
    }
}
