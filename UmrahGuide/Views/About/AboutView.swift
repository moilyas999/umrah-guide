import SwiftUI

struct AboutView: View {
    var embedsNavigation: Bool = true

    var body: some View {
        if embedsNavigation {
            NavigationStack {
                content
            }
        } else {
            content
        }
    }

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(AppCopy.appName)
                        .font(.title2.weight(.semibold))
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

                LabeledSection(title: "What this app is") {
                    Text("An offline companion. Perform walks ihram, tawaf, sa'i, and cutting the hair. Duas are their own tab — rite groups plus Personal / Everyday. Choose Arabic, how to say it, and meaning. Your ticks and place stay on this device.")
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                }

                LabeledSection(title: "What this app is not") {
                    Text("It is not a fatwa service, not a live scholar, and not a substitute for the people of knowledge you already trust. Details differ across Sunni schools.")
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                }

                LabeledSection(title: "Privacy") {
                    Text(AppCopy.noDataCollection)
                        .font(.body)
                        .foregroundStyle(Theme.ink)
                }

                VStack(spacing: 8) {
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
            .padding(.horizontal, Theme.horizontalPadding)
            .padding(.vertical, 12)
        }
        .umrahScreenBackground()
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    private static var versionString: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? AppVersion.marketing
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? AppVersion.build
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
                .font(.footnote.weight(.semibold))
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
