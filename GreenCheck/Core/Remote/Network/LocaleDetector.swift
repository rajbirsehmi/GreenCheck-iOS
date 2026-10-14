import Foundation

struct LocaleDetector {
    /// Returns the OpenFoodFacts compatible country tag for the current device region (e.g., "en:india", "en:united-states").
    static var currentDeviceCountryTag: String {
        guard let regionCode = Locale.current.region?.identifier else {
            return "en:united-states" // Default fallback
        }
        return countryTag(for: regionCode)
    }
    
    /// Converts a region code into an OFF-compatible country tag format.
    static func countryTag(for regionCode: String) -> String {
        let normalizedCode = regionCode.lowercased()
        
        // Map common country codes to OpenFoodFacts tag naming conventions
        switch normalizedCode {
        case "in":
            return "en:india"        //
        case "us":
            return "en:united-states"
        case "gb", "uk":
            return "en:united-kingdom"
        case "ca":
            return "en:canada"
        case "au":
            return "en:australia"
        case "de":
            return "en:germany"
        case "fr":
            return "en:france"
        case "jp":
            return "en:japan"
        case "mx":
            return "en:mexico"
        case "br":
            return "en:brazil"
        case "it":
            return "en:italy"        //
        case "es":
            return "en:spain"
        case "nl":
            return "en:netherlands"
        case "ch":
            return "en:switzerland"
        case "se":
            return "en:sweden"
        case "nz":
            return "en:new-zealand"
        default:
            // Generic fallback pattern for any unmapped regions
            return "en:\(normalizedCode)"
        }
    }
}
