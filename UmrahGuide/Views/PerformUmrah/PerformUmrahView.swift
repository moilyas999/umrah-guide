import SwiftUI

struct PerformUmrahView: View {
    @EnvironmentObject private var performStore: PerformStore
    @State private var showPack = false
    @State private var showDuas = false
    @State private var showLearnMore = false
    @State private var showDuaDetail = false
    @State private var showPronunciation = false
    @State private var confirmRestart = false

    private var step: PerformStep { performStore.currentStep }
    private var primaryDua: Dua? {
        step.primaryDuaID.flatMap(DuaCatalog.dua(id:))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        stagePicker
                        progressLabel
                        if performStore.isFirst {
                            DisclaimerBanner(compact: true)
                        }
                        titleBlock
                        doNowBlock
                        jargonBlock
                        womenBlock
                        cautionBlock
                        prayBlock
                        moreDuasLink
                        doneToggle
                        learnMoreLink
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
                footer
            }
            .umrahScreenBackground()
            .navigationTitle("Perform")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showPack = true
                    } label: {
                        Label("Pack", systemImage: "checklist")
                    }
                    .accessibilityHint("Opens the packing list. Your place here is saved.")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showDuas = true
                    } label: {
                        Label("Duas", systemImage: "text.book.closed")
                    }
                    .accessibilityHint("Opens duas. Your place here is saved.")
                }
            }
            .sheet(isPresented: $showPack) {
                ChecklistView()
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showDuas) {
                DuasView(initialOccasion: sheetOccasion)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showLearnMore) {
                NavigationStack {
                    RitualStepDetailView(step: RitualCatalog.step(id: step.stage.ritualID))
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Done") { showLearnMore = false }
                            }
                        }
                }
            }
            .sheet(isPresented: $showDuaDetail) {
                if let primaryDua {
                    NavigationStack {
                        DuaDetailView(dua: primaryDua)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button("Done") { showDuaDetail = false }
                                }
                            }
                    }
                }
            }
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

    private var sheetOccasion: DuaOccasion {
        switch step.stage {
        case .ihram: return .ihram
        case .tawaf:
            if step.id == "enter-haram" { return .enteringHaram }
            if step.id == "first-sight" { return .firstSightKaaba }
            if step.id == "maqam" { return .maqamIbrahim }
            if step.id == "zamzam" { return .zamzam }
            return .tawaf
        case .sai: return .sai
        case .halqTaqsir: return .halqTaqsir
        }
    }

    private var stagePicker: some View {
        HStack(spacing: 8) {
            ForEach(PerformStage.allCases) { stage in
                let selected = step.stage == stage
                Button {
                    performStore.jumpToStage(stage)
                    showPronunciation = false
                } label: {
                    Text(stage.title)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .foregroundStyle(selected ? Theme.page : Theme.ink)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(selected ? Theme.accent : Theme.card)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(selected ? Theme.accent : Theme.ink.opacity(0.12), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(stage.title). \(stage.meaning)")
                .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
                .accessibilityHint("Jumps to this stage. Your current place is saved.")
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var progressLabel: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(step.stage.title) · \(step.stage.meaning)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.accent)
            Text("Step \(performStore.stepIndex + 1) of \(PerformCatalog.steps.count)")
                .font(.headline)
                .foregroundStyle(Theme.ink)
            ProgressView(value: Double(performStore.stepIndex + 1), total: Double(PerformCatalog.steps.count))
                .tint(Theme.accent)
                .accessibilityHidden(true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(step.stage.title). Step \(performStore.stepIndex + 1) of \(PerformCatalog.steps.count). \(step.title)")
    }

    private var titleBlock: some View {
        Text(step.title)
            .font(.largeTitle.weight(.bold))
            .foregroundStyle(Theme.ink)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityAddTraits(.isHeader)
    }

    private var doNowBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(step.doNow.enumerated()), id: \.offset) { _, sentence in
                Text(sentence)
                    .font(.title3)
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(step.doNow.joined(separator: " "))
    }

    @ViewBuilder
    private var jargonBlock: some View {
        if let jargon = step.jargon {
            Text(jargon)
                .font(.body)
                .foregroundStyle(Theme.muted)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityLabel(jargon)
        }
    }

    @ViewBuilder
    private var womenBlock: some View {
        if let note = step.womenNote {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "person.2.fill")
                    .foregroundStyle(Theme.accent)
                    .accessibilityHidden(true)
                Text(note)
                    .font(.body)
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .umrahCard()
            .accessibilityElement(children: .combine)
            .accessibilityLabel("When women differ. \(note)")
        }
    }

    @ViewBuilder
    private var cautionBlock: some View {
        if let caution = step.caution {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundStyle(Theme.gold)
                    .accessibilityHidden(true)
                Text(caution)
                    .font(.body.weight(.medium))
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.gold.opacity(0.14))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Watch for this. \(caution)")
        }
    }

    @ViewBuilder
    private var prayBlock: some View {
        if let primaryDua {
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    showDuaDetail = true
                } label: {
                    PrayThisNowCard(dua: primaryDua, showsPronunciation: showPronunciation)
                }
                .buttonStyle(.plain)
                .accessibilityHint("Opens the full dua with the source note")

                Button(showPronunciation ? "Hide how to say it" : "Show how to say it") {
                    showPronunciation.toggle()
                }
                .font(.body.weight(.semibold))
                .foregroundStyle(Theme.accent)
                .frame(minHeight: 44)
                .accessibilityHint("Shows or hides the English pronunciation")
            }
        }
    }

    private var moreDuasLink: some View {
        Button {
            showDuas = true
        } label: {
            HStack {
                Label(primaryDua == nil ? "Need a dua?" : "More duas for this stage", systemImage: "text.book.closed")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                Spacer()
                Image(systemName: "chevron.forward")
                    .foregroundStyle(Theme.muted)
                    .accessibilityHidden(true)
            }
            .frame(minHeight: 44)
        }
        .buttonStyle(.plain)
        .accessibilityHint("Opens duas without losing this step")
    }

    private var doneToggle: some View {
        let checked = performStore.isDone(step.id)
        return Button {
            performStore.toggleDone(step.id)
        } label: {
            HStack(spacing: 14) {
                Image(systemName: checked ? "checkmark.circle.fill" : "circle")
                    .font(.largeTitle)
                    .foregroundStyle(checked ? Theme.accent : Theme.muted)
                    .accessibilityHidden(true)
                Text("I've done this")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.ink)
                Spacer()
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: Theme.thumbHeight)
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(checked ? Theme.accent : Theme.ink.opacity(0.16), lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("I've done this")
        .accessibilityValue(checked ? "Checked" : "Not checked")
        .accessibilityAddTraits(.isButton)
    }

    private var learnMoreLink: some View {
        Button {
            showLearnMore = true
        } label: {
            Text("More detail on \(step.stage.title)")
                .font(.body.weight(.semibold))
                .foregroundStyle(Theme.muted)
                .frame(minHeight: 44)
        }
        .buttonStyle(.plain)
        .accessibilityHint("Opens the longer guide for this stage")
    }

    private var footer: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                ThumbSecondaryButton("Back", systemImage: "chevron.backward", enabled: !performStore.isFirst) {
                    showPronunciation = false
                    performStore.goBack()
                }

                if performStore.isLast {
                    ThumbPrimaryButton("Start over", systemImage: "arrow.counterclockwise") {
                        confirmRestart = true
                    }
                } else {
                    ThumbPrimaryButton("Next", systemImage: "chevron.forward") {
                        showPronunciation = false
                        performStore.advance()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(Theme.page)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Theme.ink.opacity(0.08))
                .frame(height: 1)
        }
    }
}

#Preview {
    PerformUmrahView()
        .environmentObject(PerformStore(defaults: UserDefaults(suiteName: "preview.perform") ?? .standard))
        .environmentObject(ChecklistStore(defaults: UserDefaults(suiteName: "preview.checklist") ?? .standard))
}
