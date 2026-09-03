import SwiftUI

struct ChecklistView: View {
    @EnvironmentObject private var store: ChecklistStore
    @State private var confirmReset = false

    private var total: Int { ChecklistCatalog.items.count }
    private var done: Int { store.checkedCount(in: ChecklistCatalog.items) }
    private var progress: Double { total == 0 ? 0 : Double(done) / Double(total) }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ScreenLead(subtitle: "Ihram and packing reminders. Ticks stay on this iPhone only.")

                    progressBlock

                    if total == 0 {
                        EmptyState(
                            title: "Nothing to pack",
                            message: "This list is empty on this device."
                        )
                    } else {
                        ForEach(ChecklistCategory.allCases) { category in
                            categorySection(category)
                        }
                    }
                }
                .padding(.horizontal, Theme.horizontalPadding)
                .padding(.vertical, 12)
            }
            .umrahScreenBackground()
            .navigationTitle("Pack")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset") {
                        confirmReset = true
                    }
                    .disabled(done == 0)
                    .accessibilityHint("Clears every checked item on this device")
                }
            }
            .alert("Reset checklist?", isPresented: $confirmReset) {
                Button("Reset", role: .destructive) {
                    store.reset()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This only clears ticks stored on this iPhone. Nothing is sent anywhere.")
            }
        }
    }

    private var progressBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(progressTitle)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.ink)
            ProgressView(value: progress)
                .tint(Theme.accent)
                .accessibilityHidden(true)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(progressTitle)
        .accessibilityValue(progressPercentLabel)
    }

    private var progressTitle: String {
        if total == 0 {
            return "No items"
        }
        if done == total {
            return "All \(total) items packed"
        }
        return "\(done) of \(total) packed"
    }

    private var progressPercentLabel: String {
        let percent = Int((progress * 100).rounded())
        return "\(percent) percent"
    }

    private func categorySection(_ category: ChecklistCategory) -> some View {
        let items = ChecklistCatalog.items.filter { $0.category == category }
        let checked = store.checkedCount(in: items)

        return VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(category.title)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                Spacer()
                Text("\(checked)/\(items.count)")
                    .font(.footnote)
                    .foregroundStyle(Theme.muted)
                    .accessibilityHidden(true)
            }
            .padding(.bottom, 8)
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel("\(category.title), \(checked) of \(items.count) checked")

            VStack(spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    ChecklistRow(item: item)
                    if index < items.count - 1 {
                        Divider()
                            .background(Theme.hairline)
                            .padding(.leading, 36)
                    }
                }
            }
            .umrahCard()
        }
    }
}

private struct ChecklistRow: View {
    @EnvironmentObject private var store: ChecklistStore
    let item: ChecklistItem

    var body: some View {
        let checked = store.isChecked(item.id)

        Button {
            store.toggle(item.id)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: checked ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(checked ? Theme.accent : Theme.muted)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.body.weight(.medium))
                        .foregroundStyle(Theme.ink)
                        .multilineTextAlignment(.leading)
                    Text(item.detail)
                        .font(.footnote)
                        .foregroundStyle(Theme.muted)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, minHeight: Theme.minTap, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(item.title)
        .accessibilityValue(checked ? "Checked" : "Not checked")
        .accessibilityHint(item.detail)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    ChecklistView()
        .environmentObject(ChecklistStore(defaults: UserDefaults(suiteName: "preview.checklist") ?? .standard))
}
