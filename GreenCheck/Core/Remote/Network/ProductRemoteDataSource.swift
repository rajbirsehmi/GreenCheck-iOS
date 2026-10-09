import Foundation

protocol ProductRemoteDataSource {
    func getProductDTO(barcode: String) async throws -> ProductDTO
    func fetchAlternativesDTO(categoryTag: String) async throws -> [ProductDTO]
}
