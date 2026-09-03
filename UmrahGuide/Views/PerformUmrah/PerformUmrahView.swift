import SwiftUI

struct PerformUmrahView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ScreenHeader(
                        title: "Perform Umrah",
                        subtitle: "A calm, high-level walk through the four well-known stages, in the common Sunni order."
                    )

                    DisclaimerBanner()

                    VStack(alignment: .leading, spacing: 10) {
                        Text("The four stages")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(Theme.ink)
                            .accessibilityAddTraits(.isHeader)

                        Text("Move through them in order. Each card opens what to do, common mistakes, and where women’s practice commonly differs.")
                            .font(.body)
                            .foregroundStyle(Theme.muted)
                    }

                    ForEach(RitualCatalog.steps) { step in
                        NavigationLink(value: step.id) {
                            RitualStepRow(step: step)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .umrahScreenBackground()
            .navigationTitle("Perform Umrah")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: RitualID.self) { id in
                RitualStepDetailView(step: RitualCatalog.step(id: id))
            }
        }
    }
}

private struct RitualStepRow: View {
    let step: RitualStep

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            Text("\(step.order)")
                .font(.title2.weight(.bold))
                .foregroundStyle(Theme.page)
                .frame(width: 44, height: 44)
                .background(Theme.accent)
                .clipShape(Circle())
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Label(step.title, systemImage: step.systemImage)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                    .labelStyle(.titleAndIcon)
                Text(step.subtitle)
                    .font(.subheadline)
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
        .accessibilityLabel("Step \(step.order) of \(RitualCatalog.steps.count), \(step.title). \(step.subtitle)")
        .accessibilityHint("Opens the full guide for this step")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    PerformUmrahView()
}
