import SwiftUI

struct AppShapes {
    // Native iOS Continuous Corner Metrics
    static let cornerSmall: CGFloat = 10
    static let cornerMedium: CGFloat = 12
    static let cornerLarge: CGFloat = 16

    static let small = RoundedRectangle(cornerRadius: cornerSmall, style: .continuous)
    static let medium = RoundedRectangle(cornerRadius: cornerMedium, style: .continuous)
    static let large = RoundedRectangle(cornerRadius: cornerLarge, style: .continuous)
}
