import SwiftUI

struct DisclaimerBanner: View {
    var compact: Bool = false

    var body: some View {
        Text(compact ? AppCopy.shortDisclaimer : AppCopy.educationalDisclaimer)
            .font(.footnote)
            .foregroundStyle(Theme.muted)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isStaticText)
            .accessibilityLabel(compact ? AppCopy.shortDisclaimer : AppCopy.educationalDisclaimer)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        DisclaimerBanner()
        DisclaimerBanner(compact: true)
    }
    .padding()
    .background(Theme.page)
}
