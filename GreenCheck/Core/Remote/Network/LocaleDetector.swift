import Foundation
//
//extension OpenFoodFactsURLBuilder {
//    
//    /// Returns the OFF tag for the user's current device region (e.g. "en:united-states")
//    static var currentDeviceCountryTag: String? {
//        // Read region identifier from current locale (e.g. "US")
//        guard let regionCode = Locale.current.region?.identifier else {
//            return nil
//        }
//        return countryTag(for: regionCode)
//    }
//}
//
//// Usage:
//if let userCountryTag = OpenFoodFactsURLBuilder.currentDeviceCountryTag {
//    print("User OFF Tag:", userCountryTag) // e.g., "en:united-states"
//}
