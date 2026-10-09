import Foundation
import SwiftData
import AVFoundation
import Observation

@Observable
final class ScannerViewModel {
    private let repo: ProductRepository
    
    var product: ProductItem?
    var isLoading: Bool = false
    var errorMessage: String?
    var isTorchOn: Bool = false
    var cameraPermissionGranted: Bool = false
    var isScanningEnabled: Bool = true

    init(context: ModelContext) {
        let localDS = ProductLocalDataSourceImpl(context: context)
        self.repo = ProductRepositoryImpl(localDataSource: localDS)
        checkCameraPermission()
    }

    init(repo: ProductRepository) {
        self.repo = repo
        checkCameraPermission()
    }

    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraPermissionGranted = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.cameraPermissionGranted = granted
                }
            }
        default:
            cameraPermissionGranted = false
        }
    }

    func toggleTorch() {
        isTorchOn.toggle()
        ScannerViewController.toggleTorch(on: isTorchOn)
    }

    func disableScannerForQuotaExceeded() {
        isScanningEnabled = false
        if isTorchOn {
            toggleTorch()
        }
    }

    @MainActor
    func processScannedBarcode(_ barcode: String) async {
        // Strict guard against processing barcode calls if scanning is disabled or quota is zero
        guard isScanningEnabled, QuotaManager.shared.canScan else { return }
        
        isScanningEnabled = false
        isLoading = true
        errorMessage = nil

        do {
            if let cachedProduct = await repo.getCachedProduct(byBarcode: barcode) {
                self.product = cachedProduct
                self.isLoading = false
                return
            }

            let remoteProduct = try await repo.getProduct(byBarcode: barcode, source: .scanner)
            self.product = remoteProduct
        } catch {
            self.errorMessage = "No product found for barcode \"\(barcode)\"."
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                if QuotaManager.shared.canScan {
                    self?.isScanningEnabled = true
                }
            }
        }

        isLoading = false
    }

    func resetScanner() {
        product = nil
        errorMessage = nil
        isScanningEnabled = QuotaManager.shared.canScan
    }
}
