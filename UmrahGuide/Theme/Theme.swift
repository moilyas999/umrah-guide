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
    static let thumbHeight: CGFloat = 56
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

struct ThumbPrimaryButton: View {
    let title: String
    let systemImage: String?
    let enabled: Bool
    let action: () -> Void

    init(_ title: String, systemImage: String? = nil, enabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.enabled = enabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                if let systemImage {
                    Image(systemName: systemImage)
                }
            }
            .font(.title2.weight(.bold))
            .frame(maxWidth: .infinity, minHeight: Theme.thumbHeight)
            .foregroundStyle(Theme.page)
            .background(enabled ? Theme.accent : Theme.muted.opacity(0.35))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityAddTraits(.isButton)
    }
}

struct ThumbSecondaryButton: View {
    let title: String
    let systemImage: String?
    let enabled: Bool
    let action: () -> Void

    init(_ title: String, systemImage: String? = nil, enabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.enabled = enabled
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .font(.title3.weight(.semibold))
            .frame(maxWidth: .infinity, minHeight: Theme.thumbHeight)
            .foregroundStyle(enabled ? Theme.ink : Theme.muted)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Theme.ink.opacity(0.16), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .accessibilityAddTraits(.isButton)
    }
}
