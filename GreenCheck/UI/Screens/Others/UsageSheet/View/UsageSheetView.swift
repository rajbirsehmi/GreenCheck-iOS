import SwiftUI

struct UsageSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var quotaManager = QuotaManager.shared
    @State private var showPrivacySheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("API Usage & Limits")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color.primary)

                        Text("To protect Open Food Facts infrastructure, daily lookup quotas are enforced locally on your device.")
                            .font(.subheadline)
                            .foregroundStyle(Color.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Progress Cards
                    VStack(spacing: 16) {
                        QuotaProgressCard(
                            title: "Scanner Lookups",
                            icon: "barcode.viewfinder",
                            current: quotaManager.scannerCount,
                            limit: quotaManager.dailyLimit
                        )

                        QuotaProgressCard(
                            title: "Manual Lookups",
                            icon: "keyboard",
                            current: quotaManager.manualCount,
                            limit: quotaManager.dailyLimit
                        )
                    }

                    // Reset Timer Info Box
                    HStack(spacing: 14) {
                        Image(systemName: "clock.arrow.2.circlepath")
                            .font(.title3)
                            .foregroundStyle(Color.accentColor)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Automatic Daily Refresh")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primary)

                            Text("Quotas reset automatically at 12:00 AM midnight local time.")
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(uiColor: .secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    // Transparency Sheet Trigger
                    Button {
                        showPrivacySheet = true
                    } label: {
                        Label("Data & Privacy Transparency", systemImage: "shield.pattern.checkered")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppColors.primary)
                    .padding(.top, 8)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
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
            .sheet(isPresented: $showPrivacySheet) {
                PrivacyAndTransparencyView()
                    .presentationDetents([.large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

// MARK: - HIG Quota Progress Card
private struct QuotaProgressCard: View {
    let title: String
    let icon: String
    let current: Int
    let limit: Int

    private var progress: Double {
        Double(current) / Double(limit)
    }

    private var statusColor: Color {
        if current >= limit { return .red }
        if current >= limit - 2 { return .orange }
        return AppColors.primary
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Label(title, systemImage: icon)
                    .font(.headline)
                    .foregroundStyle(Color.primary)

                Spacer()

                Text("\(current) / \(limit)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .monospacedDigit()
                    .foregroundStyle(statusColor)
            }

            ProgressView(value: min(progress, 1.0))
                .tint(statusColor)
        }
        .padding(16)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
