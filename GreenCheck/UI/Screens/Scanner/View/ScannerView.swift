import SwiftUI
import SwiftData

struct ScannerView: View {
    @Binding var selectedTab: Int
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ScannerViewModel?
    @State private var showQuotaAlert = false
    private let quotaManager = QuotaManager.shared

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let viewModel = viewModel {
                if !viewModel.cameraPermissionGranted {
                    permissionDeniedView
                } else if !quotaManager.canScan {
                    // Camera session is not instantiated when quota is exhausted
                    quotaDepletedCameraView
                } else {
                    ZStack {
                        ScannerPreviewView { barcode in
                            Task {
                                await viewModel.processScannedBarcode(barcode)
                            }
                        }
                        .ignoresSafeArea()

                        viewfinderOverlay

                        VStack {
                            topControlsBar(viewModel: viewModel)
                            Spacer()
                            bottomInstructionCard(viewModel: viewModel)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                }
            }
        }
        .navigationTitle("Scanner")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: Binding(
            get: { viewModel?.product },
            set: {
                viewModel?.product = $0
                if $0 == nil { viewModel?.resetScanner() }
            }
        )) { product in
            ProductView(product: product)
        }
        .onAppear {
            if viewModel == nil {
                viewModel = ScannerViewModel(context: modelContext)
            }

            if !quotaManager.canScan {
                viewModel?.disableScannerForQuotaExceeded()
                showQuotaAlert = true
            } else {
                viewModel?.resetScanner()
            }
        }
//        .alert("Quota Depleted for Today", isPresented: $showQuotaAlert) {
//            Button("OK", role: .cancel) {
//                selectedTab = 0 // Navigate back to Home
//            }
//        } message: {
//            Text("You've reached your daily limit of 10 scanner lookups. Your limit will refresh tonight at midnight.")
//        }
    }
}

// MARK: - Subviews
private extension ScannerView {

    var viewfinderOverlay: some View {
        GeometryReader { geometry in
            let frameWidth: CGFloat = min(geometry.size.width - 64, 280)
            let frameHeight: CGFloat = 180

            ZStack {
                Color.black.opacity(0.55)
                    .mask(
                        Rectangle()
                            .overlay(
                                RoundedRectangle(cornerRadius: AppShapes.cornerMedium, style: .continuous)
                                    .frame(width: frameWidth, height: frameHeight)
                                    .blendMode(.destinationOut)
                            )
                    )
                    .compositingGroup()

                RoundedRectangle(cornerRadius: AppShapes.cornerMedium, style: .continuous)
                    .stroke(AppColors.primary, lineWidth: 2.5)
                    .frame(width: frameWidth, height: frameHeight)
                    .shadow(color: AppColors.primary.opacity(0.4), radius: 6)
            }
            .ignoresSafeArea()
        }
    }

    func topControlsBar(viewModel: ScannerViewModel) -> some View {
        HStack {
            QuotaBadgeView(
                current: quotaManager.scannerCount,
                limit: quotaManager.dailyLimit,
                icon: "barcode.viewfinder"
            )

            Spacer()
            
            Button {
                viewModel.toggleTorch()
            } label: {
                Image(systemName: viewModel.isTorchOn ? "bolt.fill" : "bolt.slash.fill")
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(viewModel.isTorchOn ? .yellow : .white)
                    .padding(12)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
        }
    }

    func bottomInstructionCard(viewModel: ScannerViewModel) -> some View {
        VStack(spacing: 12) {
            if viewModel.isLoading {
                HStack(spacing: 12) {
                    ProgressView()
                        .tint(AppColors.primary)
                    Text("Fetching Product Details...")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
            } else if let errorMsg = viewModel.errorMessage {
                Text(errorMsg)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.error)
                    .multilineTextAlignment(.center)
            } else {
                Text("Align barcode within the viewfinder frame")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
        .clipShape(AppShapes.medium)
        .padding(.bottom, 16)
    }

    var quotaDepletedCameraView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(AppColors.error.opacity(0.12))
                    .frame(width: 88, height: 88)

                Image(systemName: "camera.metering.unknown")
                    .font(.system(size: 38))
                    .foregroundStyle(AppColors.error)
            }

            VStack(spacing: 8) {
                Text("Scan Quota Depleted")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text("Camera is turned off. Your daily lookup limit will refresh tonight at midnight.")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.onSurfaceVariant)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button {
                selectedTab = 0
            } label: {
                Text("Return to Home")
                    .font(.headline)
                    .foregroundStyle(AppColors.onPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.primary)
                    .clipShape(AppShapes.medium)
            }
            .padding(.horizontal, 32)
        }
    }

    var permissionDeniedView: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(AppColors.error.opacity(0.12))
                    .frame(width: 88, height: 88)

                Image(systemName: "camera.metering.unknown")
                    .font(.system(size: 38))
                    .foregroundStyle(AppColors.error)
            }

            VStack(spacing: 8) {
                Text("Camera Access Required")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.onBackground)

                Text("Please enable camera access in iOS Settings to scan barcodes directly.")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.onSurfaceVariant)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("Open Settings")
                    .font(.headline)
                    .foregroundStyle(AppColors.onPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(AppColors.primary)
                    .clipShape(AppShapes.medium)
            }
            .padding(.horizontal, 32)
        }
    }
}

// MARK: - Reusable Quota Badge Component
struct QuotaBadgeView: View {
    let current: Int
    let limit: Int
    let icon: String

    private var isDepleted: Bool { current >= limit }
    private var isWarning: Bool { current >= limit - 2 }

    private var badgeColor: Color {
        if isDepleted { return .red }
        if isWarning { return .orange }
        return AppColors.primary
    }

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isDepleted ? "exclamationmark.triangle.fill" : icon)
                .font(.caption2)
                .fontWeight(.bold)

            if isDepleted {
                Text("Limit Reached (0 left)")
                    .font(.caption)
                    .fontWeight(.semibold)
            } else {
                Text("\(limit - current) Left (\(current)/\(limit))")
                    .font(.caption)
                    .fontWeight(.medium)
                    .monospacedDigit()
            }
        }
        .foregroundStyle(badgeColor)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
}
