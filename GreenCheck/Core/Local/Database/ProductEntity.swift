import Foundation
import SwiftData

@Model
final class ProductEntity {
    @Attribute(.unique) var id: String
    var name: String
    var brand: String
    var imageUrl: String?
    var ingredientsText: String
    var ingredientsData: Data
    var analysisTags: [String]
    var categoriesTags: [String]
    var createdAt: Date

    init(
        id: String,
        name: String,
        brand: String,
        imageUrl: String?,
        ingredientsText: String,
        ingredientsData: Data,
        analysisTags: [String],
        categoriesTags: [String],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.imageUrl = imageUrl
        self.ingredientsText = ingredientsText
        self.ingredientsData = ingredientsData
        self.analysisTags = analysisTags
        self.categoriesTags = categoriesTags
        self.createdAt = createdAt
    }
}

// MARK: - SwiftData Entity <-> Domain Mappers
extension ProductEntity {
    convenience init(from item: ProductItem) {
        let encodedIngredients = (try? JSONEncoder().encode(item.ingredients)) ?? Data()
        self.init(
            id: item.id,
            name: item.name,
            brand: item.brand,
            imageUrl: item.imageUrl,
            ingredientsText: item.ingredientsText,
            ingredientsData: encodedIngredients,
            analysisTags: item.analysisTags,
            categoriesTags: item.categoriesTags,
            createdAt: Date()
        )
    }

    func toDomain() -> ProductItem {
        let ingredients = (try? JSONDecoder().decode([IngredientItem].self, from: ingredientsData)) ?? []
        return ProductItem(
            id: id,
            name: name,
            brand: brand,
            imageUrl: imageUrl,
            ingredientsText: ingredientsText,
            ingredients: ingredients,
            analysisTags: analysisTags,
            categoriesTags: categoriesTags
        )
    }
}
