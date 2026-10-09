import Foundation

struct ProductResponseDTO: Codable {
    let code: String?
    let status: Int?
    let statusVerbose: String?
    let product: ProductDTO?
}
