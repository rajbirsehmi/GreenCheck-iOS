import Foundation

enum DietaryStatus: String, Codable, CaseIterable {
    case yes
    case no
    case maybe
    case unknown

    var displayName: String {
        switch self {
        case .yes: return "Yes"
        case .no: return "No"
        case .maybe: return "Maybe"
        case .unknown: return "Unknown"
        }
    }
}
