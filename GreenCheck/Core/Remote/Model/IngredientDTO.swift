import Foundation

struct IngredientDTO: Codable {
    let id: String?
    let text: String?
    let vegan: String?
    let vegetarian: String?
    let percentEstimate: Double?
    let quantityEstimate: Double?
    let isInTaxonomy: Int?
    let ciqualFoodCode: String?
    let ciqualProxyFoodCode: String?
    let ecobalyseCode: String?
    let fromPalmOil: String?
    let labels: String?

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case vegan
        case vegetarian
        case percentEstimate = "percent_estimate"
        case quantityEstimate = "quantity_estimate"
        case isInTaxonomy = "is_in_taxonomy"
        case ciqualFoodCode = "ciqual_food_code"
        case ciqualProxyFoodCode = "ciqual_proxy_food_code"
        case ecobalyseCode = "ecobalyse_code"
        case fromPalmOil = "from_palm_oil"
        case labels
    }
}
