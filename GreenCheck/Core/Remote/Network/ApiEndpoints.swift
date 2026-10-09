//
//  ApiEndpoints.swift
//  GreenCheck
//
//  Created by Rajbir Singh Sehmi on 10/6/26.
//

import Foundation

struct ApiEndpoints {
    
    private let baseUrl: String = "https://world.openfoodfacts.org/api/v2"
    
    private let featureSearchProduct: String = "/product"
    private let featureSearchAlternatives: String = "/search"
        
    // ?fields=code,product_name,brands,image_url,image_front_url,ingredients_analysis_tags,ingredients,ingredients_text,categories_tags,labels_tags
    private let fieldsSearchProduct: String = "?fields=code,product_name,brands,image_url,image_front_url,ingredients_analysis_tags,ingredients,ingredients_text,categories_tags,labels_tags"
    
    // &fields=code,product_name,brands,image_url,image_front_url,ingredients_analysis_tags,ingredients,ingredients_text,categories_tags,labels_tags
    private let fieldsSearchAlternatives: String = "&fields=code,product_name,brands,image_url,image_front_url,ingredients_analysis_tags,ingredients,ingredients_text,categories_tags,labels_tags"
    
    // https://world.openfoodfacts.org/api/v2/product/016000264601.json
    func searchProductFromApi(barcode: String) -> String {
        return "\(baseUrl)\(featureSearchProduct)/\(barcode).json\(fieldsSearchProduct)"
    }
    
    // https://world.openfoodfacts.org/api/v2/search?categories_tags_en=en:snacks&ingredients_analysis_tags=en:vegan&page_size=15
    func searchAlternativesFromApi(tagProductCategory: String) -> String {
        let tags = "?categories_tags_en=\(tagProductCategory)&ingredients_analysis_tags=en:vegan&page_size=15"
        return "\(baseUrl)\(featureSearchAlternatives)\(tags)\(fieldsSearchProduct)"
    }
}
