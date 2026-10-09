import Foundation

struct IngredientItem: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let vegan: DietaryStatus
    let vegetarian: DietaryStatus
    let percentage: Double?
}
