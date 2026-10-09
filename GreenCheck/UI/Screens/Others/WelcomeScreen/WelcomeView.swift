import SwiftUI

struct WelcomeView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 36) {
                    // Hero Header Section
                    VStack(spacing: 16) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
                            .padding(.top, 40)

                        Text("Welcome to GreenCheck")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.primary)
                            .minimumScaleFactor(0.8)
                            .padding(.horizontal, 24)

                        Text("Your fast, privacy-focused companion for conscious dietary choices.")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)
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
                .padding(.bottom, 24)
            }

            // Bottom Action Section
            VStack(spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Text("Get Started")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.accentColor)

                Text("Powered by Open Food Facts")
                    .font(.caption2)
                    .foregroundStyle(Color.secondary)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 24)
            .background(Color(uiColor: .systemBackground))
        }
        .background(Color(uiColor: .systemBackground).ignoresSafeArea())
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
            ZStack {
                Circle()
                    .fill(Color(uiColor: .secondarySystemFill))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(iconColor)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color.primary)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// MARK: - Preview Context
#Preview {
    WelcomeView()
}
