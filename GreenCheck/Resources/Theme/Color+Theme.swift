import SwiftUI
import UIKit

struct AppColors {
    // Standard iOS Dynamic Semantic Colors
    static let background = Color(uiColor: .systemGroupedBackground)
    static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    static let surfaceVariant = Color(uiColor: .tertiarySystemGroupedBackground)
    
    // Label Hierarchy
    static let onBackground = Color(uiColor: .label)
    static let onSurface = Color(uiColor: .label)
    static let onSurfaceVariant = Color(uiColor: .secondaryLabel)
    static let outline = Color(uiColor: .separator)

    // Tint & Accent (Botanical Green Accent mapped to System Accent)
    static let primary = Color.accentColor
    static let onPrimary = Color.white
    static let primaryContainer = Color(uiColor: .systemGray6)
    static let onPrimaryContainer = Color(uiColor: .label)

    // Status Colors (HIG Compliant)
    static let veganStatusGreen = Color.green
    static let nonVeganStatusRed = Color.red
    static let uncertainStatusYellow = Color.orange
    static let error = Color.red
}
