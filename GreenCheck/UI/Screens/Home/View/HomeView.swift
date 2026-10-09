import SwiftUI

struct HomeView: View {
    var body: some View {
        List {
            // Header Banner with App Logo
            Section {
                VStack(spacing: 12) {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 72)
                        .clipShape(AppShapes.large)
                        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)

                    Text("Discover Conscious Eating")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.onBackground)

                    Text("Instantly verify dietary status via product barcodes.")
                        .font(.subheadline)
                        .foregroundStyle(AppColors.onSurfaceVariant)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .listRowBackground(Color.clear)
            }

            // Quick Features Section
            Section("Features") {
                FeatureRow(
                    title: "Manual Search",
                    subtitle: "Type UPC or barcode numbers directly",
                    icon: "keyboard",
                    iconColor: .blue
                )
                
                FeatureRow(
                    title: "Scan History",
                    subtitle: "Access recently inspected products",
                    icon: "clock.fill",
                    iconColor: .orange
                )

                FeatureRow(
                    title: "Camera Scanner",
                    subtitle: "Scan product barcodes instantly",
                    icon: "barcode.viewfinder",
                    iconColor: .green
                )
            }

            // How It Works
            Section("How It Works") {
                Text("GreenCheck analyzes food product ingredients via Open Food Facts. Scanned items are displayed with clear dietary indicators and ingredient breakdowns.")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.onSurfaceVariant)
            }

            // Disclaimer
            Section(
                header: Text("Disclaimer"),
                footer: Text("Product data provided by Open Food Facts contributors.")
            ) {
                Text("This app is intended for informational purposes only. Always double-check packaging labels for critical dietary requirements or severe allergies.")
                    .font(.caption)
                    .foregroundStyle(AppColors.onSurfaceVariant)
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct FeatureRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(width: 30, height: 30)
                .background(iconColor)
                .clipShape(AppShapes.small)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(AppColors.onBackground)

                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(AppColors.onSurfaceVariant)
            }
        }
        .padding(.vertical, 2)
    }
}
