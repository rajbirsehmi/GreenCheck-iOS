import Foundation

struct ApiEndpoints {
    
    private let baseUrl: String = "https://world.openfoodfacts.org/api/v2"
    
    private let featureSearchProduct: String = "/product"
    private let featureSearchAlternatives: String = "/search"
        
    private let fieldsSearchProduct: String = "?fields=code,product_name,brands,image_url,image_front_url,ingredients_analysis_tags,ingredients,ingredients_text,categories_tags,labels_tags"
    
    // https://world.openfoodfacts.org/api/v2/product/016000264601.json
    func searchProductFromApi(barcode: String) -> String {
        return "\(baseUrl)\(featureSearchProduct)/\(barcode).json\(fieldsSearchProduct)"
    }
    
    // https://world.openfoodfacts.org/api/v2/search?categories_tags_en=en:snacks&ingredients_analysis_tags=en:vegan&countries_tags_en=en:united-states&page_size=15
    func searchAlternativesFromApi(
        tagProductCategory: String,
        countryTag: String = LocaleDetector.currentDeviceCountryTag
    ) -> String {
        let tags = "?categories_tags_en=\(tagProductCategory)&ingredients_analysis_tags=en:vegan&countries_tags_en=\(countryTag)&page_size=15"
        return "\(baseUrl)\(featureSearchAlternatives)\(tags)\(fieldsSearchProduct)"
    }
}
