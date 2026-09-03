import SwiftUI

enum LegalDocument: String, Identifiable {
    case privacy
    case support

    var id: String { rawValue }

    var title: String {
        switch self {
        case .privacy: return "Privacy policy"
        case .support: return "Support"
        }
    }

    var paragraphs: [String] {
        switch self {
        case .privacy:
            return LegalCopy.privacyParagraphs
        case .support:
            return LegalCopy.supportParagraphs
        }
    }
}

enum LegalCopy {
    static let privacyParagraphs = [
        "Umrah Guide is published by DeskLink.ai (Mohammed Ilyas). Bundle identifier: \(AppCopy.bundleID).",
        "The app does not collect personal data. There is no account, no sign-in, no analytics, no advertising, no crash reporter, and no third-party SDK.",
        "The app does not use the network. It does not request location. It does not access your contacts, photos, microphone, or camera.",
        "The only information stored is which checklist rows you have ticked. That list is saved on this device with Apple’s UserDefaults. It is not uploaded, synced, or shared.",
        "App Store Privacy Nutrition Label: Data Not Collected.",
        "If this policy ever changes, the copy in the app and the copy at \(AppCopy.githubPagesBase)/privacy.html will be updated together. Today both say the same thing: nothing personal is collected."
    ]

    static let supportParagraphs = [
        "Umrah Guide is a free, offline educational companion. It does not replace a scholar, a travel agent, or the official instructions of the Kingdom of Saudi Arabia.",
        "If a screen looks wrong, a dua’s source note is unclear, or VoiceOver misses a control, open an issue on the public repository: github.com/moilyas999/umrah-guide.",
        "Please do not send passport scans, booking references, or other personal documents. Support does not need them, and this project is not a place to store them.",
        "Religious questions that decide what you must do should go to a qualified scholar. This app will not issue a ruling.",
        "Publisher: DeskLink.ai. Independent App Store listing.",
        "A web copy of this page for App Store Connect is intended at \(AppCopy.githubPagesBase)/support.html when GitHub Pages is enabled for the docs folder."
    ]
}

struct LegalDocumentView: View {
    let document: LegalDocument

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(document.title)
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(Theme.ink)
                    .accessibilityAddTraits(.isHeader)

                ForEach(Array(document.paragraphs.enumerated()), id: \.offset) { _, paragraph in
                    Text(paragraph)
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .umrahScreenBackground()
        .navigationTitle(document.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
