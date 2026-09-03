import SwiftUI

struct DisclaimerBanner: View {
    var compact: Bool = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "info.circle.fill")
                .font(.title3)
                .foregroundStyle(Theme.gold)
                .accessibilityHidden(true)

            Text(compact ? AppCopy.shortDisclaimer : AppCopy.educationalDisclaimer)
                .font(compact ? .footnote : .subheadline)
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.gold.opacity(0.14))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Theme.gold.opacity(0.45), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isStaticText)
        .accessibilityLabel(compact ? AppCopy.shortDisclaimer : AppCopy.educationalDisclaimer)
    }
}

#Preview {
    VStack {
        DisclaimerBanner()
        DisclaimerBanner(compact: true)
    }
    .padding()
    .background(Theme.page)
}
