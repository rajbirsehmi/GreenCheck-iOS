import Foundation

final class ProductRemoteDataSourceImpl: ProductRemoteDataSource {
    private let session: URLSession
    private let apiEndpoints = ApiEndpoints()
    private let userAgent: String = "GreenCheck - iOS - Version 1.0 - https://www.github.com/rajbirsehmi/GreenCheck-iOS"

    init(session: URLSession = .shared) {
        self.session = session
    }

    func getProductDTO(barcode: String) async throws -> ProductDTO {
        guard let url = URL(string: apiEndpoints.searchProductFromApi(barcode: barcode)) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            // This will print or throw the exact status code (e.g. 429, 503, 404)
            throw NetworkError.httpStatusError(statusCode: httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(OpenFoodFactsResponse.self, from: data)
            
            guard let productDTO = apiResponse.product else {
                throw NetworkError.productNotFound
            }
            return productDTO
        } catch {
            throw NetworkError.decodingError(error: error)
        }
    }

    func fetchAlternativesDTO(categoryTag: String) async throws -> [ProductDTO] {
        guard let url = URL(string: apiEndpoints.searchAlternativesFromApi(tagProductCategory: categoryTag)) else {
            print(NetworkError.invalidURL)
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.setValue(userAgent, forHTTPHeaderField: "User-Agent")

        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print(NetworkError.invalidResponse)
            throw NetworkError.invalidResponse
        }
        
        guard httpResponse.statusCode == 200 else {
            print(NetworkError.httpStatusError(statusCode: httpResponse.statusCode))
            throw NetworkError.httpStatusError(statusCode: httpResponse.statusCode)
        }

        do {
            let decoder = JSONDecoder()
            let searchResult = try decoder.decode(OpenFoodFactsSearchResponse.self, from: data)
            return searchResult.products ?? []
        } catch {
            print(NetworkError.decodingError(error: error))
            throw NetworkError.decodingError(error: error)
        }
    }
}
