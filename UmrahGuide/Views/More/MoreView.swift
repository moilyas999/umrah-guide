import SwiftUI

struct MoreView: View {
    @EnvironmentObject private var performStore: PerformStore
    @State private var confirmRestart = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ScreenHeader(
                        title: "More",
                        subtitle: "Duas, about this app, and your saved place. Nothing leaves this iPhone."
                    )

                    NavigationLink {
                        DuasView(embedsNavigation: false)
                    } label: {
                        MoreRow(
                            title: "All duas",
                            subtitle: "Browse by stage. Arabic, how to say it, meaning, and an honest source note.",
                            systemImage: "text.book.closed"
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        AboutView(embedsNavigation: false)
                    } label: {
                        MoreRow(
                            title: "About and privacy",
                            subtitle: "Educational guide. No account, no ads, no tracking.",
                            systemImage: "info.circle"
                        )
                    }
                    .buttonStyle(.plain)

                    LabeledSection(title: "Your place", systemImage: "figure.walk") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Perform is on step \(performStore.stepIndex + 1) of \(PerformCatalog.steps.count): \(performStore.currentStep.title).")
                                .font(.title3)
                                .foregroundStyle(Theme.ink)
                                .fixedSize(horizontal: false, vertical: true)

                            Button("Start Perform from the beginning") {
                                confirmRestart = true
                            }
                            .font(.body.weight(.semibold))
                            .foregroundStyle(Theme.danger)
                            .frame(minHeight: 44)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .umrahScreenBackground()
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.inline)
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
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(Theme.accent)
                .frame(width: 36)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.ink)
                Text(subtitle)
                    .font(.body)
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            Image(systemName: "chevron.forward")
                .font(.body.weight(.semibold))
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
