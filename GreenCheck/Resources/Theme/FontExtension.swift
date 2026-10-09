import SwiftUI
import UIKit

public enum PoppinsWeight {
    case thin
    case extraLight
    case light
    case regular
    case medium
    case semiBold
    case bold
    case extraBold
    case black
    
    // PostScript font names matching your registered TTF files
    var name: String {
        switch self {
        case .thin:       return "Poppins-Thin"
        case .extraLight: return "Poppins-ExtraLight"
        case .light:      return "Poppins-Light"
        case .regular:    return "Poppins-Regular"
        case .medium:     return "Poppins-Medium"
        case .semiBold:   return "Poppins-SemiBold"
        case .bold:       return "Poppins-Bold"
        case .extraBold:  return "Poppins-ExtraBold"
        case .black:      return "Poppins-Black"
        }
    }
}

// MARK: - UIKit Helper
public func customUIFont(
    _ weight: PoppinsWeight = .regular,
    size: CGFloat,
    relativeTo textStyle: UIFont.TextStyle = .body
) -> UIFont {
    guard let customFont = UIFont(name: weight.name, size: size) else {
        return UIFont.systemFont(ofSize: size)
    }
    return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: customFont)
}

// MARK: - SwiftUI Font Extension
extension Font {
    static func poppins(
        _ weight: PoppinsWeight = .regular,
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle = .body
    ) -> Font {
        Font.custom(weight.name, size: size, relativeTo: textStyle)
    }
}
