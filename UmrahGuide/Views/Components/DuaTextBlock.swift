import SwiftUI

/// Renders a dua according to the persisted Arabic / transliteration / meaning filter.
struct DuaTextBlock: View {
    let dua: Dua
    var showsTitle: Bool = true
    var compact: Bool = false

    @EnvironmentObject private var display: DuaDisplayStore

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 10 : 12) {
            if showsTitle {
                Text(dua.title)
                    .font(.headline)
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if display.options.showsArabic {
                Text(dua.arabic)
                    .font(compact ? .title3 : .title2)
                    .foregroundStyle(Theme.ink)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .environment(\.layoutDirection, .rightToLeft)
                    .textSelection(.enabled)
                    .minimumScaleFactor(0.75)
                    .accessibilityLabel("Arabic. \(dua.transliteration)")
            }

            if display.options.showsTransliteration {
                VStack(alignment: .leading, spacing: 2) {
                    Text("How to say it")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.muted)
                        .accessibilityHidden(true)
                    Text(dua.transliteration)
                        .font(.body)
                        .italic()
                        .foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                        .textSelection(.enabled)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Transliteration. \(dua.transliteration)")
            }

            if display.options.showsMeaning {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Meaning")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Theme.muted)
                        .accessibilityHidden(true)
                    Text(dua.meaning)
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Meaning. \(dua.meaning)")
            }

            if !display.options.showsAnyText {
                Text("Turn on Arabic, how to say it, or meaning above.")
                    .font(.footnote)
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    private var accessibilityLabel: String {
        var parts = [dua.title]
        if display.options.showsTransliteration {
            parts.append(dua.transliteration)
        } else if display.options.showsArabic {
            parts.append(dua.transliteration)
        }
        if display.options.showsMeaning {
            parts.append(dua.meaning)
        }
        return parts.joined(separator: ". ")
    }
}

#Preview {
    ScrollView {
        DuaTextBlock(dua: DuaCatalog.duas[0])
            .umrahCard()
            .padding()
    }
    .umrahScreenBackground()
    .environmentObject(DuaDisplayStore(defaults: UserDefaults(suiteName: "preview.display") ?? .standard))
}
