import SwiftUI

struct RitualStepDetailView: View {
    let step: RitualStep

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Step \(step.order) of \(RitualCatalog.steps.count)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                    Text(step.title)
                        .font(.largeTitle.weight(.semibold))
                        .foregroundStyle(Theme.ink)
                        .accessibilityAddTraits(.isHeader)
                    Text(step.subtitle)
                        .font(.body)
                        .foregroundStyle(Theme.muted)
                }

                DisclaimerBanner(compact: true)

                LabeledSection(title: "What to do", systemImage: "checkmark.circle") {
                    VStack(alignment: .leading, spacing: 14) {
                        ForEach(Array(step.whatToDo.enumerated()), id: \.offset) { index, point in
                            NumberedPoint(number: index + 1, text: point)
                        }
                    }
                }

                LabeledSection(title: "Common mistakes", systemImage: "exclamationmark.triangle") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(Array(step.commonMistakes.enumerated()), id: \.offset) { _, mistake in
                            HStack(alignment: .top, spacing: 10) {
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

                LabeledSection(title: "When women differ", systemImage: "person.2") {
                    Text(step.womenNotes)
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }

                relatedDuas
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .umrahScreenBackground()
        .navigationTitle(step.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var relatedDuas: some View {
        if let occasion = occasionForStep {
            let matches = DuaCatalog.duas(for: occasion)
            if !matches.isEmpty {
                LabeledSection(title: "Related duas", systemImage: "text.book.closed") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Open the Duas tab for Arabic, transliteration, and source notes. Nothing here is a required script for every circuit or leg.")
                            .font(.subheadline)
                            .foregroundStyle(Theme.muted)

                        ForEach(matches) { dua in
                            Text(dua.title)
                                .font(.body.weight(.medium))
                                .foregroundStyle(Theme.ink)
                        }
                    }
                }
            }
        }
    }

    private var occasionForStep: DuaOccasion? {
        switch step.id {
        case .ihram: return .ihram
        case .tawaf: return .tawaf
        case .sai: return .sai
        case .halqTaqsir: return nil
        }
    }
}

#Preview {
    NavigationStack {
        RitualStepDetailView(step: RitualCatalog.step(id: .ihram))
    }
}
