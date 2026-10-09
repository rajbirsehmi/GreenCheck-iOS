import Foundation
import SwiftData
import Observation

@Observable
final class ManualViewModel {
    private let repo: ProductRepository
    
    var product: ProductItem?
    var isLoading: Bool = false
    var errorMessage: String?
    var showErrorAlert: Bool = false
    
    init(context: ModelContext) {
        let localDS = ProductLocalDataSourceImpl(context: context)
        self.repo = ProductRepositoryImpl(localDataSource: localDS)
    }
    
    init(repo: ProductRepository) {
        self.repo = repo
    }

    @MainActor
    func fetchProduct(from barcode: String) async {
        isLoading = true
        errorMessage = nil
        showErrorAlert = false
        
        do {
            if let cachedProduct = await repo.getCachedProduct(byBarcode: barcode) {
                self.product = cachedProduct
                self.isLoading = false
                return
            }
            
            let remoteProduct = try await repo.getProduct(byBarcode: barcode, source: .manual)
            self.product = remoteProduct
        } catch {
            self.errorMessage = error.localizedDescription
            self.showErrorAlert = true
        }
        
        isLoading = false
    }
}
