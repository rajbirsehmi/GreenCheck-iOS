import Foundation

struct ProductItem: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let brand: String
    let imageUrl: String?
    let ingredientsText: String
    let ingredients: [IngredientItem]
    let analysisTags: [String]
    let categoriesTags: [String]
    
    // Computed property (excluded from JSON automatically)
    var veganStatus: DietaryStatus {
        if ingredients.contains(where: { $0.vegan == .no }) { return .no }
        if ingredients.contains(where: { $0.vegan == .maybe }) { return .maybe }
        if ingredients.allSatisfy({ $0.vegan == .yes }) && !ingredients.isEmpty { return .yes }
        return .unknown
    }
}
