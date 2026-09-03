import SwiftUI

/// Compact closed “Dua for …” row. Expanding reveals Arabic / transliteration / meaning
/// according to the persisted display filter.
struct CollapsibleDuaRow: View {
    let dua: Dua
    var startsExpanded: Bool = false
    var showsDetailLink: Bool = false
    var style: Style = .card

    enum Style {
        case card
        case inset
    }

    @EnvironmentObject private var display: DuaDisplayStore
    @State private var isExpanded = false

    var body: some View {
        let presentation = DuaExpansion.presentations(
            duas: [dua],
            expandedIDs: isExpanded ? Set([dua.id]) : [],
            options: display.options
        ).first

        return VStack(alignment: .leading, spacing: 0) {
            header(presentation)
            if isExpanded {
                expandedContent(presentation)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 14)
                    .padding(.top, 2)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(rowBackground)
        .clipShape(RoundedRectangle(cornerRadius: rowRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: rowRadius, style: .continuous)
                .stroke(Theme.ink.opacity(style == .card ? 0.06 : 0.08), lineWidth: 1)
        )
        .onAppear {
            if startsExpanded {
                isExpanded = true
            }
        }
        .accessibilityElement(children: isExpanded ? .contain : .combine)
    }

    private var rowBackground: Color {
        style == .card ? Theme.card : Theme.accent.opacity(0.06)
    }

    private var rowRadius: CGFloat {
        style == .card ? Theme.cardRadius : 14
    }

    private func header(_ presentation: CollapsibleDuaPresentation?) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        } label: {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(presentation?.title ?? DuaExpansion.collapsedTitle(for: dua))
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Theme.ink)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(presentation?.label ?? DuaExpansion.collapsedLabel(for: dua))
                        .font(.footnote)
                        .foregroundStyle(Theme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(Theme.muted)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: Theme.minTap, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(presentation?.collapsedAccessibilityLabel ?? DuaExpansion.collapsedTitle(for: dua))
        .accessibilityHint(isExpanded ? "Hides the dua text" : "Shows the dua text")
        .accessibilityAddTraits(.isButton)
    }

    @ViewBuilder
    private func expandedContent(_ presentation: CollapsibleDuaPresentation?) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if let presentation, presentation.isExpanded {
                if presentation.showsAnyBodyText {
                    DuaTextBlock(dua: dua, showsTitle: false, compact: true)
                } else {
                    Text("Turn on Arabic, how to say it, or meaning above.")
                        .font(.footnote)
                        .foregroundStyle(Theme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            if showsDetailLink {
                NavigationLink {
                    DuaDetailView(dua: dua)
                } label: {
                    Text("When to say it and source")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Theme.accent)
                        .frame(minHeight: 44, alignment: .leading)
                }
                .accessibilityHint("Opens the source note and when to say this dua")
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 12) {
            CollapsibleDuaRow(dua: DuaCatalog.duas[0])
            CollapsibleDuaRow(dua: DuaCatalog.duas[1], style: .inset)
        }
        .padding()
    }
    .umrahScreenBackground()
    .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.collapse") ?? .standard))
}
