import XCTest
@testable import GreenCheck
import SwiftData

@MainActor
final class ProductFlowTests: XCTestCase {
    var modelContainer: ModelContainer!
    var localDataSource: ProductLocalDataSourceImpl!

    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: ProductEntity.self, configurations: config)
        localDataSource = ProductLocalDataSourceImpl(context: modelContainer.mainContext)
    }

    // Flow 1 & 2: Search & Cache Verification (Manual & Camera Scanner)
    func test_productRepository_savesAndRetrievesCachedProduct() async throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "SingleProduct", withExtension: "json") else {
            XCTFail("SingleProduct.json not found")
            return
        }
        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(ProductResponseDTO.self, from: data)
        
        guard let productDTO = response.product else {
            XCTFail("Product DTO is nil")
            return
        }
        
        let product = ProductItem(from: productDTO)
        
        // Save product (simulating successful lookup)
        try await localDataSource.saveProduct(product)
        
        // Retrieve cached product
        let cached = await localDataSource.getCachedProduct(byBarcode: product.id)
        
        // Assertions for Flow 5 (History Saved) & Flow 7 (Details Correct)
        XCTAssertNotNil(cached)
        XCTAssertEqual(cached?.name, product.name)
        XCTAssertEqual(cached?.brand, product.brand)
    }

    // Flow 3: Product Not Found Handling
    func test_productNotFound_decodesAndHandlesGracefully() throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "ProductNotFound", withExtension: "json") else {
            XCTFail("ProductNotFound.json not found")
            return
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try decoder.decode(ProductResponseDTO.self, from: data)
        
        XCTAssertEqual(response.status, 0)
        XCTAssertEqual(response.statusVerbose, "product not found")
    }
}
