import XCTest
@testable import GreenCheck
import SwiftData

@MainActor
final class HistoryFlowTests: XCTestCase {
    var modelContainer: ModelContainer!
    var localDataSource: ProductLocalDataSourceImpl!
    var viewModel: HistoryViewModel!

    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: ProductEntity.self, configurations: config)
        localDataSource = ProductLocalDataSourceImpl(context: modelContainer.mainContext)
        viewModel = HistoryViewModel(repo: ProductRepositoryImpl(localDataSource: localDataSource))
    }

    // Flow 4: Search through history
    func test_historyViewModel_filtersItemsBySearchText() async throws {
        // Load product using your proven JSON mock
        guard let url = Bundle(for: type(of: self)).url(forResource: "SingleProduct", withExtension: "json") else {
            XCTFail("SingleProduct.json not found")
            return
        }
        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(ProductResponseDTO.self, from: data)
        
        if let productDTO = response.product {
            let product = ProductItem(from: productDTO)
            try await localDataSource.saveProduct(product)
        }
        
        await viewModel.fetchHistory()
        
        // Filter search using a term matching your mock product
        viewModel.searchText = viewModel.historyItems.first?.name ?? "Test"
        XCTAssertFalse(viewModel.filteredItems.isEmpty)
    }

    // Flow 6: Check if history is removed after clearing list
    func test_historyViewModel_clearsAllHistory() async throws {
        guard let url = Bundle(for: type(of: self)).url(forResource: "SingleProduct", withExtension: "json") else {
            XCTFail("SingleProduct.json not found")
            return
        }
        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(ProductResponseDTO.self, from: data)
        
        if let productDTO = response.product {
            let product = ProductItem(from: productDTO)
            try await localDataSource.saveProduct(product)
        }
        
        await viewModel.fetchHistory()
        XCTAssertFalse(viewModel.historyItems.isEmpty)
        
        // Clear history
        await viewModel.clearAll()
        
        XCTAssertTrue(viewModel.historyItems.isEmpty)
        let cachedItems = await localDataSource.getAllCachedProducts()
        XCTAssertTrue(cachedItems.isEmpty)
    }
}
