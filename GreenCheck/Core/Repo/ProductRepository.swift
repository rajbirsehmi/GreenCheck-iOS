import Foundation

protocol ProductRepository {
    func getProduct(byBarcode barcode: String, source: LookupSource) async throws -> ProductItem
    func getCachedProduct(byBarcode barcode: String) async -> ProductItem?
    func getAllCachedProducts() async -> [ProductItem]
    func isProductCached(byBarcode barcode: String) async -> Bool
    func cacheProduct(product: ProductItem) async throws
    func deleteProduct(byBarcode barcode: String) async throws
    func clearAllHistory() async throws
    func getAlternatives(categoryTag: String, currentProductId: String) async throws -> [ProductItem]
}
