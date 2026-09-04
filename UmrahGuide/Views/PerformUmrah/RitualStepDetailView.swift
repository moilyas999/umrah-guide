import SwiftUI

struct RitualStepDetailView: View {
    let step: RitualStep

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Stage \(step.order) of \(RitualCatalog.steps.count)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.muted)
                    Text(step.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(Theme.muted)
                }

                DisclaimerBanner(compact: true)

                LabeledSection(title: "What to do") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(step.whatToDo.enumerated()), id: \.offset) { index, point in
                            NumberedPoint(number: index + 1, text: point)
                        }
                    }
                }

                LabeledSection(title: "Common mistakes") {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(Array(step.commonMistakes.enumerated()), id: \.offset) { _, mistake in
                            HStack(alignment: .top, spacing: 8) {
                                Image(systemName: "xmark.circle")
                                    .foregroundStyle(Theme.danger)
                                    .accessibilityHidden(true)
                                Text(mistake)
                                    .font(.body)
                                    .foregroundStyle(Theme.ink)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .accessibilityElement(children: .combine)
                        }
                    }
                }

                LabeledSection(title: "When women differ") {
                    Text(step.womenNotes)
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }

                relatedDuas
            }
            .padding(.horizontal, Theme.horizontalPadding)
            .padding(.vertical, 12)
        }
        .umrahScreenBackground()
        .navigationTitle(step.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var relatedDuas: some View {
        let matches = relatedDuasForStep
        if !matches.isEmpty {
            LabeledSection(title: "Related duas") {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Use Perform for one dua at a time. Nothing here is a required script for every circuit or leg.")
                        .font(.footnote)
                        .foregroundStyle(Theme.muted)

                    ForEach(matches) { dua in
                        CollapsibleDuaRow(dua: dua, showsDetailLink: true, style: .inset)
                    }
                }
            }
        }
    }

    private var relatedDuasForStep: [Dua] {
        DuaCatalog.duas.filter { dua in
            switch step.id {
            case .ihram:
                return dua.occasion == .ihram
            case .tawaf:
                return [.enteringHaram, .firstSightKaaba, .tawaf, .maqamIbrahim, .zamzam].contains(dua.occasion)
            case .sai:
                return dua.occasion == .sai
            case .halqTaqsir:
                return dua.occasion == .halqTaqsir
            }
        }
    }
}

#Preview {
    NavigationStack {
        RitualStepDetailView(step: RitualCatalog.step(id: .ihram))
    }
    .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.ritual") ?? .standard))
}
