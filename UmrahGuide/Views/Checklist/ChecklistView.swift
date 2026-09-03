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
                    ScreenHeader(
                        title: "Checklist",
                        subtitle: "Ihram and packing reminders. Ticks stay on this iPhone only."
                    )

                    progressCard

                    ForEach(ChecklistCategory.allCases) { category in
                        categorySection(category)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .umrahScreenBackground()
            .navigationTitle("Checklist")
            .navigationBarTitleDisplayMode(.inline)
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

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Packed and prepared")
                .font(.headline)
                .foregroundStyle(Theme.ink)
            Text("\(done) of \(total) items")
                .font(.subheadline)
                .foregroundStyle(Theme.muted)
            ProgressView(value: progress)
                .tint(Theme.accent)
                .accessibilityHidden(true)
        }
        .umrahCard()
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Packed and prepared, \(done) of \(total) items")
        .accessibilityValue(progressPercentLabel)
    }

    private var progressPercentLabel: String {
        let percent = Int((progress * 100).rounded())
        return "\(percent) percent"
    }

    private func categorySection(_ category: ChecklistCategory) -> some View {
        let items = ChecklistCatalog.items.filter { $0.category == category }
        let checked = store.checkedCount(in: items)

        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(category.title, systemImage: category.systemImage)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Theme.accent)
                Spacer()
                Text("\(checked)/\(items.count)")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.muted)
                    .accessibilityHidden(true)
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel("\(category.title), \(checked) of \(items.count) checked")

            VStack(spacing: 10) {
                ForEach(items) { item in
                    ChecklistRow(item: item)
                }
            }
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
                    .font(.title2)
                    .foregroundStyle(checked ? Theme.accent : Theme.muted)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Theme.ink)
                        .multilineTextAlignment(.leading)
                    Text(item.detail)
                        .font(.subheadline)
                        .foregroundStyle(Theme.muted)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .umrahCard()
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
