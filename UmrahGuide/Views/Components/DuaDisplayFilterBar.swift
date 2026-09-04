import SwiftUI

/// Obvious on-screen control for any combination of Arabic, transliteration, and meaning.
struct DuaDisplayFilterBar: View {
    @EnvironmentObject private var display: DuaDisplayStore
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Show")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Theme.muted)
                .accessibilityAddTraits(.isHeader)

            if stacksVertically {
                VStack(spacing: 8) {
                    ForEach(DuaDisplayField.allCases) { field in
                        filterChip(field)
                    }
                }
            } else {
                HStack(spacing: 8) {
                    ForEach(DuaDisplayField.allCases) { field in
                        filterChip(field)
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(summaryLabel)
    }

    private var stacksVertically: Bool {
        dynamicTypeSize.isAccessibilitySize
    }

    private func filterChip(_ field: DuaDisplayField) -> some View {
        let on = display.options.shows(field)
        return Button {
            display.toggle(field)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: on ? "checkmark.circle.fill" : "circle")
                    .font(.subheadline)
                    .accessibilityHidden(true)
                Text(field.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .foregroundStyle(on ? Theme.accent : Theme.ink)
            .frame(maxWidth: .infinity, minHeight: Theme.minTap)
            .background(on ? Theme.accent.opacity(0.10) : Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(on ? Theme.accent.opacity(0.35) : Theme.hairline, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(field.accessibilityTitle)
        .accessibilityValue(on ? "Shown" : "Hidden")
        .accessibilityHint("Shows or hides this part of every dua")
        .accessibilityAddTraits(on ? [.isButton, .isSelected] : .isButton)
    }

    private var summaryLabel: String {
        let parts = DuaDisplayField.allCases.map { field in
            "\(field.accessibilityTitle) \(display.options.shows(field) ? "shown" : "hidden")"
        }
        return "Dua display. " + parts.joined(separator: ", ")
    }
}

#Preview {
    DuaDisplayFilterBar()
        .padding()
        .umrahScreenBackground()
        .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.filter") ?? .standard))
}
