import Foundation

extension ProductItem {
    init(from dto: ProductDTO) {
        self.id = dto.code ?? UUID().uuidString
        self.name = (dto.productName?.isEmpty == false) ? dto.productName! : "Unknown Product"
        self.brand = (dto.brands?.isEmpty == false) ? dto.brands! : "Unknown Brand"
        
        self.imageUrl = dto.imageFrontUrl ?? dto.imageUrl
        self.ingredientsText = dto.ingredientsText ?? ""
        self.analysisTags = dto.ingredientsAnalysisTags ?? []
        self.categoriesTags = dto.categoriesTags ?? []

        self.ingredients = (dto.ingredients ?? []).compactMap { IngredientItem(from: $0) }
    }
}

extension IngredientItem {
    init?(from dto: IngredientDTO) {
        guard let name = dto.text, !name.isEmpty else { return nil }

        self.id = dto.id ?? UUID().uuidString
        self.name = name
        self.vegan = DietaryStatus(fromOFFTag: dto.vegan)
        self.vegetarian = DietaryStatus(fromOFFTag: dto.vegetarian)
        self.percentage = dto.percentEstimate
    }
}

extension DietaryStatus {
    init(fromOFFTag tag: String?) {
        guard let tag = tag else {
            self = .unknown
            return
        }
        switch tag.lowercased() {
        case "yes", "en:yes": self = .yes
        case "no", "en:no": self = .no
        case "maybe", "en:maybe": self = .maybe
        default: self = .unknown
        }
    }
}
