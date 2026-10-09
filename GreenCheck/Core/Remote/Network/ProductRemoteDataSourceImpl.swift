import Foundation

final class ProductRemoteDataSourceImpl: ProductRemoteDataSource {
    private let session: URLSession
    private let apiEndpoints = ApiEndpoints()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getProductDTO(barcode: String) async throws -> ProductDTO {
        guard let url = URL(string: apiEndpoints.searchProductFromApi(barcode: barcode)) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(OpenFoodFactsResponse.self, from: data)
        
        guard let productDTO = apiResponse.product else {
            throw URLError(.cannotParseResponse)
        }
        
        return productDTO
    }

    func fetchAlternativesDTO(categoryTag: String) async throws -> [ProductDTO] {
        guard let url = URL(string: apiEndpoints.searchAlternativesFromApi(tagProductCategory: categoryTag)) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await session.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        let searchResult = try decoder.decode(OpenFoodFactsSearchResponse.self, from: data)
        return searchResult.products ?? []
    }
}
