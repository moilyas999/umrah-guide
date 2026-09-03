import SwiftUI

struct PerformUmrahView: View {
    @EnvironmentObject private var performStore: PerformStore
    @State private var expandedStages: Set<PerformStage> = []
    @State private var showLearnMore = false
    @State private var confirmRestart = false

    private var presentations: [PerformStagePresentation] {
        performStore.presentations(expandedStages: effectiveExpanded)
    }

    private var effectiveExpanded: Set<PerformStage> {
        expandedStages.isEmpty
            ? PerformAccordion.defaultExpanded(for: performStore.currentStage)
            : expandedStages
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        progressHeader
                        DuaDisplayFilterBar()
                        accordionList
                        learnMoreLink
                    }
                    .padding(.horizontal, Theme.horizontalPadding)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                    .umrahReadableWidth()
                }
                .umrahScreenBackground()
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    footer
                }
                .onAppear {
                    if expandedStages.isEmpty {
                        expandedStages = PerformAccordion.defaultExpanded(for: performStore.currentStage)
                    }
                    scrollToCurrent(proxy)
                }
                .onChange(of: performStore.currentStage) { _, newStage in
                    expandedStages = PerformAccordion.afterMoving(to: newStage, expanded: expandedStages)
                    scrollToCurrent(proxy)
                }
            }
            .navigationTitle("Perform")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showLearnMore) {
                NavigationStack {
                    RitualStepDetailView(step: RitualCatalog.step(id: performStore.currentStage.ritualID))
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Done") { showLearnMore = false }
                            }
                        }
                }
            }
            .alert("Start Perform from the beginning?", isPresented: $confirmRestart) {
                Button("Start over", role: .destructive) {
                    performStore.reset()
                    expandedStages = PerformAccordion.defaultExpanded(for: .ihram)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This only clears your place and ticks on this iPhone. Nothing is sent anywhere.")
            }
        }
    }

    private var progressHeader: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Step \(performStore.stepIndex + 1) of \(PerformCatalog.steps.count)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.muted)
            Text(performStore.currentStep.title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
            ProgressView(
                value: Double(performStore.stepIndex + 1),
                total: Double(PerformCatalog.steps.count)
            )
            .tint(Theme.accent)
            .accessibilityHidden(true)
            Text(AppCopy.shortDisclaimer)
                .font(.footnote)
                .foregroundStyle(Theme.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Step \(performStore.stepIndex + 1) of \(PerformCatalog.steps.count). \(performStore.currentStep.title). \(AppCopy.shortDisclaimer)")
    }

    private var accordionList: some View {
        VStack(spacing: 10) {
            ForEach(presentations) { presentation in
                StageAccordionCard(
                    presentation: presentation,
                    currentStepID: performStore.currentStep.id,
                    onToggle: {
                        expandedStages = PerformAccordion.toggle(presentation.stage, in: effectiveExpanded)
                    },
                    onSelectStep: { step in
                        performStore.goTo(stepID: step.id)
                        expandedStages = PerformAccordion.afterMoving(to: step.stage, expanded: effectiveExpanded)
                    },
                    onToggleDone: { step in
                        performStore.toggleDone(step.id)
                    },
                    isStepDone: { performStore.isDone($0) }
                )
                .id(presentation.stage)
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var learnMoreLink: some View {
        Button {
            showLearnMore = true
        } label: {
            Text("Longer guide for \(performStore.currentStage.title)")
                .font(.footnote)
                .foregroundStyle(Theme.muted)
                .frame(minHeight: 44)
        }
        .buttonStyle(.plain)
        .accessibilityHint("Opens the longer guide for this stage")
    }

    private var footer: some View {
        VStack(spacing: 4) {
            if performStore.isLast {
                ThumbPrimaryButton("Start over", systemImage: "arrow.counterclockwise") {
                    confirmRestart = true
                }
                quietBackButton
            } else {
                ThumbPrimaryButton("Next") {
                    performStore.advance()
                }
                quietBackButton
            }
        }
        .padding(.horizontal, Theme.horizontalPadding)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .umrahReadableWidth()
        .background(Theme.page)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Theme.hairline)
                .frame(height: 1)
        }
        .accessibilityElement(children: .contain)
    }

    @ViewBuilder
    private var quietBackButton: some View {
        if !performStore.isFirst {
            Button("Back") {
                performStore.goBack()
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Theme.muted)
            .frame(minHeight: 44)
            .accessibilityHint("Goes to the previous step")
        }
    }

    private func scrollToCurrent(_ proxy: ScrollViewProxy) {
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 0.25)) {
                proxy.scrollTo(performStore.currentStage, anchor: .top)
            }
        }
    }
}

#Preview {
    PerformUmrahView()
        .environmentObject(PerformStore(defaults: UserDefaults(suiteName: "preview.perform") ?? .standard))
        .environmentObject(ChecklistStore(defaults: UserDefaults(suiteName: "preview.checklist") ?? .standard))
        .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.display") ?? .standard))
}
