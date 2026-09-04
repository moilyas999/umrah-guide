import SwiftUI

struct StageAccordionCard: View {
    let presentation: PerformStagePresentation
    let currentStepID: String
    let onToggle: () -> Void
    let onSelectStep: (PerformStep) -> Void
    let onToggleDone: (PerformStep) -> Void
    let isStepDone: (String) -> Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            if presentation.isExpanded {
                expandedContent
                    .padding(.horizontal, 14)
                    .padding(.bottom, 14)
                    .padding(.top, 2)
            }
        }
        .background(Theme.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardRadius, style: .continuous)
                .stroke(borderColor, lineWidth: presentation.isCurrent ? 1.5 : 1)
        )
        .accessibilityElement(children: presentation.isExpanded ? .contain : .combine)
    }

    private var borderColor: Color {
        presentation.isCurrent ? Theme.accent.opacity(0.55) : Theme.hairline
    }

    private var header: some View {
        Button(action: onToggle) {
            HStack(alignment: .top, spacing: 10) {
                stageIndex
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 8) {
                        Text(presentation.stage.title)
                            .font(.headline)
                            .foregroundStyle(Theme.ink)
                        if presentation.isCurrent {
                            Text("Now")
                                .font(.caption2.weight(.semibold))
                                .foregroundStyle(Theme.accent)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 2)
                                .background(Theme.accent.opacity(0.12))
                                .clipShape(Capsule())
                                .accessibilityHidden(true)
                        }
                        Spacer(minLength: 8)
                        Image(systemName: presentation.isExpanded ? "chevron.up" : "chevron.down")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(Theme.muted)
                            .accessibilityHidden(true)
                    }
                    Text("Step \(presentation.progressLabel)")
                        .font(.footnote)
                        .foregroundStyle(presentation.isCurrent ? Theme.accent : Theme.muted)
                    if !presentation.isExpanded {
                        Text(presentation.actionSummary)
                            .font(.subheadline)
                            .foregroundStyle(Theme.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, minHeight: Theme.minTap, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(presentation.collapsedAccessibilityLabel)
        .accessibilityAddTraits(presentation.isCurrent ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint(presentation.isExpanded ? "Collapses this stage" : "Expands instructions and duas for this stage")
    }

    private var stageIndex: some View {
        Text("\(stageOrder)")
            .font(.caption.weight(.bold))
            .foregroundStyle(presentation.isCurrent ? Color.white : Theme.accent)
            .frame(width: 24, height: 24)
            .background(presentation.isCurrent ? Theme.accent : Theme.accent.opacity(0.12))
            .clipShape(Circle())
            .accessibilityHidden(true)
    }

    private var stageOrder: Int {
        (PerformStage.allCases.firstIndex(of: presentation.stage) ?? 0) + 1
    }

    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            stepChecklist
            if let current = focusedStep {
                currentInstructions(current)
                currentDuas(current)
            }
        }
    }

    private var focusedStep: PerformStep? {
        presentation.steps.first(where: { $0.id == currentStepID && presentation.isCurrent })
            ?? presentation.steps.first(where: { $0.id == currentStepID })
            ?? presentation.steps[safe: presentation.stepNumber - 1]
    }

    private var stepChecklist: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("In this stage")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.muted)
                .accessibilityAddTraits(.isHeader)

            ForEach(presentation.steps) { step in
                let done = isStepDone(step.id)
                let current = step.id == currentStepID
                Button {
                    onSelectStep(step)
                } label: {
                    HStack(alignment: .center, spacing: 10) {
                        Image(systemName: done ? "checkmark.circle.fill" : (current ? "circle.inset.filled" : "circle"))
                            .font(.body)
                            .foregroundStyle(done || current ? Theme.accent : Theme.muted)
                            .accessibilityHidden(true)
                        Text(step.title)
                            .font(.body.weight(current ? .semibold : .regular))
                            .foregroundStyle(Theme.ink)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer(minLength: 4)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .background(current ? Theme.accent.opacity(0.10) : Color.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(step.title)
                .accessibilityValue(current ? "Current" : (done ? "Checked" : "Not checked"))
                .accessibilityHint("Moves Perform to this step")
            }
        }
    }

    @ViewBuilder
    private func currentInstructions(_ step: PerformStep) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Do this")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.muted)
                .accessibilityAddTraits(.isHeader)

            ForEach(Array(step.doNow.enumerated()), id: \.offset) { _, sentence in
                Text(sentence)
                    .font(.body)
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let jargon = step.jargon {
                Text(jargon)
                    .font(.footnote)
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let note = step.womenNote {
                labeledNote(systemImage: "person.2", text: note, accessibilityPrefix: "When women differ")
            }

            if let caution = step.caution {
                labeledNote(systemImage: "exclamationmark.triangle", text: caution, accessibilityPrefix: "Watch for this")
            }

            Button {
                onToggleDone(step)
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: isStepDone(step.id) ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(isStepDone(step.id) ? Theme.accent : Theme.muted)
                        .accessibilityHidden(true)
                    Text("I've done this")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Theme.ink)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .frame(maxWidth: .infinity, minHeight: Theme.minTap, alignment: .leading)
                .background(Theme.accent.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("I've done this")
            .accessibilityValue(isStepDone(step.id) ? "Checked" : "Not checked")
        }
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private func currentDuas(_ step: PerformStep) -> some View {
        let stepDuas = DuaExpansion.duas(for: step)

        if !stepDuas.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(stepDuas.count == 1 ? "Dua" : "Duas for this step")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Theme.muted)
                    .accessibilityAddTraits(.isHeader)

                ForEach(stepDuas) { dua in
                    CollapsibleDuaRow(dua: dua, style: .inset)
                }
            }
        }
    }

    private func labeledNote(systemImage: String, text: String, accessibilityPrefix: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: systemImage)
                .font(.footnote)
                .foregroundStyle(Theme.muted)
                .accessibilityHidden(true)
            Text(text)
                .font(.footnote)
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(accessibilityPrefix). \(text)")
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
