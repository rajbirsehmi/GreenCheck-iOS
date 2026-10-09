import Foundation
import SwiftData
import Observation

@Observable
final class ProductViewModel {
    private let repo: ProductRepository

    var alternativeProducts: [ProductItem] = []
    var isLoadingAlternatives: Bool = false
    var alternativeError: String?

    init(context: ModelContext) {
        let localDS = ProductLocalDataSourceImpl(context: context)
        self.repo = ProductRepositoryImpl(localDataSource: localDS)
    }

    init(repo: ProductRepository) {
        self.repo = repo
    }

    @MainActor
    func fetchAlternatives(for product: ProductItem) async {
        guard product.veganStatus != .yes else { return }

        isLoadingAlternatives = true
        alternativeError = nil

        // Look specifically for English category tags (e.g., "en:cereal-bars" or "en:snacks")
        let categoryTag = product.categoriesTags.first(where: { $0.hasPrefix("en:") }) ?? "en:snacks"

        do {
            let results = try await repo.getAlternatives(categoryTag: categoryTag, currentProductId: product.id)
            self.alternativeProducts = results

            if self.alternativeProducts.isEmpty {
                self.alternativeError = "No verified vegan alternatives found."
            }
        } catch {
            self.alternativeError = "Unable to load alternatives at this time."
        }

        isLoadingAlternatives = false
    }
}
