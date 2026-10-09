import SwiftUI

struct WelcomeView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 32) {
                    // Hero Header Section with App Logo
                    VStack(spacing: 16) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(AppShapes.large)
                            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                            .padding(.top, 36)

                        Text("Welcome to GreenCheck")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(AppColors.onBackground)
                            .minimumScaleFactor(0.8)
                            .lineLimit(2)
                            .padding(.horizontal, 24)

                        Text("Your fast, privacy-focused companion for conscious dietary choices.")
                            .font(.subheadline)
                            .foregroundStyle(AppColors.onSurfaceVariant)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    // Feature Highlights Section
                    VStack(alignment: .leading, spacing: 24) {
                        OnboardingFeatureRow(
                            icon: "barcode.viewfinder",
                            iconColor: .green,
                            title: "Instant Barcode Scanning",
                            description: "Use your camera to scan packaged food items and retrieve immediate ingredient analyses."
                        )

                        OnboardingFeatureRow(
                            icon: "checkmark.seal.fill",
                            iconColor: .blue,
                            title: "Dietary Verifications",
                            description: "Instantly check whether products meet vegan or vegetarian dietary standards."
                        )

                        OnboardingFeatureRow(
                            icon: "clock.arrow.circlepath",
                            iconColor: .orange,
                            title: "Local Offline History",
                            description: "Your scan history is saved privately on your device for quick access anytime."
                        )
                    }
                    .padding(.horizontal, 24)
                }
            }

            // Bottom Action Section
            VStack(spacing: 16) {
                Button {
                    dismiss()
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.onPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(AppColors.primary)
                        .clipShape(AppShapes.medium)
                }

                Text("Powered by Open Food Facts")
                    .font(.caption2)
                    .foregroundStyle(AppColors.onSurfaceVariant)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 24)
            .background(AppColors.background.ignoresSafeArea(edges: .bottom))
        }
        .background(AppColors.background.ignoresSafeArea())
        .interactiveDismissDisabled()
    }
}

// MARK: - Feature Row Component
private struct OnboardingFeatureRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let description: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
                .frame(width: 44, height: 44)
                .background(iconColor.opacity(0.12))
                .clipShape(AppShapes.small)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(AppColors.onBackground)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(AppColors.onSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
