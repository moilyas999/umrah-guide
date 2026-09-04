import SwiftUI

struct MoreView: View {
    @EnvironmentObject private var performStore: PerformStore
    @State private var confirmRestart = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ScreenLead(subtitle: "About this app and your saved place. Nothing leaves this iPhone.")

                    NavigationLink {
                        AboutView(embedsNavigation: false)
                    } label: {
                        MoreRow(
                            title: MoreItem.about.title,
                            subtitle: "Educational guide. No account, no ads, no tracking.",
                            systemImage: "info.circle"
                        )
                    }
                    .buttonStyle(.plain)

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your place")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Theme.ink)
                            .accessibilityAddTraits(.isHeader)

                        Text("Perform is on step \(performStore.stepIndex + 1) of \(PerformCatalog.steps.count): \(performStore.currentStep.title).")
                            .font(.body)
                            .foregroundStyle(Theme.ink)
                            .fixedSize(horizontal: false, vertical: true)

                        Button(MoreItem.restartPerform.title) {
                            confirmRestart = true
                        }
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Theme.danger)
                        .frame(minHeight: 44)
                    }
                    .umrahCard()
                }
                .padding(.horizontal, Theme.horizontalPadding)
                .padding(.vertical, 12)
            }
            .umrahScreenBackground()
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.large)
            .alert("Start Perform from the beginning?", isPresented: $confirmRestart) {
                Button("Start over", role: .destructive) {
                    performStore.reset()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This only clears your place and ticks on this iPhone. Nothing is sent anywhere.")
            }
        }
    }
}

private struct MoreRow: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(Theme.accent)
                .frame(width: 28)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Theme.ink)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.forward")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(Theme.muted)
                .accessibilityHidden(true)
        }
        .umrahCard()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(subtitle)")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    MoreView()
        .environmentObject(PerformStore(defaults: UserDefaults(suiteName: "preview.perform") ?? .standard))
        .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.more") ?? .standard))
}
