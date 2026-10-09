import SwiftUI

struct PrivacyAndTransparencyView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    private let odblLicenseURL = URL(string: "https://opendatacommons.org/licenses/odbl/1-0/")!

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header Title
                    Text("Privacy & Transparency")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.primary)
                        .padding(.top, 8)

                    // Feature Items
                    VStack(alignment: .leading, spacing: 20) {
                        PrivacyAndTransparencyFeatureRow(
                            icon: "dollarsign.circle.fill",
                            title: "100% Free & Ad-Free",
                            description: "GreenCheck is a passion project. I don't charge money, show ads, or monetize your usage in any way."
                        )

                        PrivacyAndTransparencyFeatureRow(
                            icon: "iphone.slash",
                            title: "Strictly Local Experience",
                            description: "No accounts, no cloud sync, and no data collection. Your scan history and settings stay entirely on your device."
                        )

                        PrivacyAndTransparencyFeatureRow(
                            icon: "gauge.with.needle.fill",
                            title: "Per-Device Usage Limits",
                            description: "To ensure the Open Food Facts API remains available for everyone, we enforce a small daily lookup limit strictly on your device. Your next quota refresh is scheduled every night at 12."
                        )

                        PrivacyAndTransparencyFeatureRow(
                            icon: "chevron.left.forwardslash.chevron.right",
                            title: "Open Source Integrity",
                            description: "Transparency is core to our mission. You can audit our code on GitHub to verify how we handle (or rather, don't handle) your data."
                        )

                        PrivacyAndTransparencyFeatureRow(
                            icon: "shield.checkered",
                            title: "Data & Licensing",
                            description: "All product data is retrieved from Open Food Facts and is governed by the Open Database License (ODbL). You can use and redistribute this data according to the license terms."
                        )
                    }

                    // Action Button Section (Audit Button Skipped)
                    VStack {
                        Link(destination: odblLicenseURL) {
                            HStack {
                                Spacer()
                                Text("ODbL License")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            .padding(.vertical, 14)
                            .background(Color.accentColor.opacity(0.15))
                            .foregroundStyle(Color.accentColor)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                    .padding(.top, 12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .background(Color(uiColor: .systemBackground))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - HIG Feature Item Subview
private struct PrivacyAndTransparencyFeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Circle Icon Container
            ZStack {
                Circle()
                    .fill(Color(uiColor: .secondarySystemFill))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
            }

            // Text Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.primary)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                    .lineSpacing(2)
            }
        }
    }
}

// MARK: - Preview Sheet Context
#Preview {
    Text("Host Screen")
        .sheet(isPresented: .constant(true)) {
            PrivacyAndTransparencyView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
}
