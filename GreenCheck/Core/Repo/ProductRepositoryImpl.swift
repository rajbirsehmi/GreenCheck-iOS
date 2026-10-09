import Foundation

struct ProductRepositoryImpl: ProductRepository {
    private let remoteDataSource: ProductRemoteDataSource
    private let localDataSource: ProductLocalDataSource
    private let quotaManager: QuotaManager

    init(
        remoteDataSource: ProductRemoteDataSource = ProductRemoteDataSourceImpl(),
        localDataSource: ProductLocalDataSource,
        quotaManager: QuotaManager = .shared
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        self.quotaManager = quotaManager
    }

    func getProduct(byBarcode barcode: String, source: LookupSource) async throws -> ProductItem {
        let remoteDTO = try await remoteDataSource.getProductDTO(barcode: barcode)
        let domainProduct = ProductItem(from: remoteDTO)

        // Increment quota strictly on successful remote responses (valid product names)
        if domainProduct.name != "Unknown Product" {
            switch source {
            case .scanner:
                quotaManager.incrementScannerCount()
            case .manual:
                quotaManager.incrementManualCount()
            }
        }

        do {
            try await localDataSource.saveProduct(domainProduct)
        } catch {
            print("⚠️ Cache warning: Failed to cache fetched product: \(error.localizedDescription)")
        }

        return domainProduct
    }

    func getCachedProduct(byBarcode barcode: String) async -> ProductItem? {
        await localDataSource.getCachedProduct(byBarcode: barcode)
    }

    func getAllCachedProducts() async -> [ProductItem] {
        await localDataSource.getAllCachedProducts()
    }

    func isProductCached(byBarcode barcode: String) async -> Bool {
        await localDataSource.isProductCached(byBarcode: barcode)
    }

    func cacheProduct(product: ProductItem) async throws {
        try await localDataSource.saveProduct(product)
    }

    func deleteProduct(byBarcode barcode: String) async throws {
        try await localDataSource.deleteProduct(byBarcode: barcode)
    }

    func clearAllHistory() async throws {
        try await localDataSource.clearAllHistory()
    }

    func getAlternatives(categoryTag: String, currentProductId: String) async throws -> [ProductItem] {
        let dtos = try await remoteDataSource.fetchAlternativesDTO(categoryTag: categoryTag)
        let domainItems = dtos.map { ProductItem(from: $0) }
        
        return domainItems.filter { $0.id != currentProductId && $0.veganStatus == .yes }
    }
}
