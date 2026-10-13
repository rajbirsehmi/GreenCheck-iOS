import XCTest
@testable import GreenCheck

final class MockJsonLoaderTests: XCTestCase {
    
    func test_loadSingleProductMock_decodesSuccessfully() throws {
        // Given your mock file path in the test bundle
        guard let url = Bundle(for: type(of: self)).url(forResource: "SingleProduct", withExtension: "json") else {
            XCTFail("SingleProduct.json mock not found")
            return
        }
        
        // When
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let productDTO = try decoder.decode(ProductDTO.self, from: data)
        
        // Then
        XCTAssertNotNil(productDTO)
        let product = ProductItem(from: productDTO)
        XCTAssertFalse(product.name.isEmpty)
    }
    
    func test_loadAlternateSuggestionsMock_decodesSuccessfully() throws {
        // Given
        guard let url = Bundle(for: type(of: self)).url(forResource: "AlternateSuggestions", withExtension: "json") else {
            XCTFail("AlternateSuggestions.json mock not found")
            return
        }
        
        // When
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        // Decode based on your search response DTO structure
        let searchResponse = try decoder.decode(OpenFoodFactsSearchResponse.self, from: data)
        
        // Then
        XCTAssertNotNil(searchResponse)
        let domainItems = searchResponse.products?.map { ProductItem(from: $0) } ?? []
        XCTAssertTrue(domainItems.isEmpty == false)
    }
    
    func test_loadProductNotFoundMock_decodesSuccessfully() throws {
            // Given
            guard let url = Bundle(for: type(of: self)).url(forResource: "ProductNotFound", withExtension: "json") else {
                XCTFail("ProductNotFound.json mock not found")
                return
            }

            // When
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let responseDTO = try decoder.decode(ProductResponseDTO.self, from: data)

            // Then
            XCTAssertNotNil(responseDTO)
            XCTAssertEqual(responseDTO.code, "0123456789")
            XCTAssertEqual(responseDTO.status, 0)
            XCTAssertEqual(responseDTO.statusVerbose, "product not found")
            XCTAssertNotNil(responseDTO.product) // It decodes the empty product container gracefully
        }
}
