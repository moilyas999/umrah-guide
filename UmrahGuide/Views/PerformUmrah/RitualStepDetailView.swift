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
        let matches = relatedDuasForStep
        if !matches.isEmpty {
            LabeledSection(title: "Related duas", systemImage: "text.book.closed") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Use Perform for one dua at a time. Nothing here is a required script for every circuit or leg.")
                        .font(.body)
                        .foregroundStyle(Theme.muted)

                    ForEach(matches) { dua in
                        NavigationLink {
                            DuaDetailView(dua: dua)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(dua.title)
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(Theme.ink)
                                Text(dua.meaning)
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.muted)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .buttonStyle(.plain)
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
}
