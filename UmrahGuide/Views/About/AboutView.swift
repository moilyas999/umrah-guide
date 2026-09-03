import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(AppCopy.appName)
                            .font(.largeTitle.weight(.semibold))
                            .foregroundStyle(Theme.ink)
                            .accessibilityAddTraits(.isHeader)
                        Text("Version \(Self.versionString)")
                            .font(.subheadline)
                            .foregroundStyle(Theme.muted)
                        Text("An independent educational app from \(AppCopy.publisher), created by \(AppCopy.author).")
                            .font(.body)
                            .foregroundStyle(Theme.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    DisclaimerBanner()

                    LabeledSection(title: "What this app is", systemImage: "book") {
                        Text("A quiet, offline companion for the common stages of Umrah: ihram, tawaf, sa'i, and halq or taqsir. It stores only your checklist ticks on this device.")
                            .font(.body)
                            .foregroundStyle(Theme.ink)
                    }

                    LabeledSection(title: "What this app is not", systemImage: "slash.circle") {
                        Text("It is not a fatwa service, not a live scholar, and not a substitute for the people of knowledge you already trust. Details differ across Sunni schools.")
                            .font(.body)
                            .foregroundStyle(Theme.ink)
                    }

                    LabeledSection(title: "Privacy", systemImage: "lock.shield") {
                        Text(AppCopy.noDataCollection)
                            .font(.body)
                            .foregroundStyle(Theme.ink)
                    }

                    VStack(spacing: 10) {
                        NavigationLink {
                            LegalDocumentView(document: .privacy)
                        } label: {
                            AboutLinkRow(title: "Privacy policy", systemImage: "doc.text")
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            LegalDocumentView(document: .support)
                        } label: {
                            AboutLinkRow(title: "Support", systemImage: "questionmark.circle")
                        }
                        .buttonStyle(.plain)
                    }

                    Text("The same documents are published for App Store review as GitHub Pages at \(AppCopy.githubPagesBase)/ when Pages is enabled on the public repository. The app itself never opens the network.")
                        .font(.footnote)
                        .foregroundStyle(Theme.muted)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .umrahScreenBackground()
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private static var versionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}

private struct AboutLinkRow: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
                .font(.body.weight(.semibold))
                .foregroundStyle(Theme.ink)
            Spacer()
            Image(systemName: "chevron.forward")
                .foregroundStyle(Theme.muted)
                .accessibilityHidden(true)
        }
        .umrahCard()
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    AboutView()
}
