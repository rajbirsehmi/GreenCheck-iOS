//
//  GreenCheckApp.swift
//  GreenCheck
//
//  Created by Rajbir Singh Sehmi on 10/6/26.
//

import SwiftUI
import SwiftData

@main
struct GreenCheckApp: App {
    
    init() {
        applyCustomFont()
    }
    
    var body: some Scene {
        WindowGroup {
            HostScreen()
        }
        .modelContainer(for: [ProductEntity.self])
    }
    
    func applyCustomFont() {
        // Helper closure to generate scaled UIFont with weight mapping and fallback
        func customUIFont(_ weight: PoppinsWeight = .regular, size: CGFloat, relativeTo style: UIFont.TextStyle = .body) -> UIFont {
            guard let customFont = UIFont(name: weight.name, size: size) else {
                return UIFont.preferredFont(forTextStyle: style)
            }
            return UIFontMetrics(forTextStyle: style).scaledFont(for: customFont)
        }
        
        // 1. Navigation Bar - Inline / Standard Title (SemiBold)
        UINavigationBar.appearance().titleTextAttributes = [
            .font: customUIFont(.semiBold, size: 18, relativeTo: .headline)
        ]
        
        // 2. Navigation Bar - Large Title (Bold)
        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font: customUIFont(.bold, size: 34, relativeTo: .largeTitle)
        ]
        
        // 3. Navigation Bar Buttons (Medium)
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .font: customUIFont(.medium, size: 16, relativeTo: .body)
        ], for: .normal)
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            .font: customUIFont(.medium, size: 16, relativeTo: .body)
        ], for: .highlighted)
        
        // 4. Tab Bar Items (Medium for unselected, SemiBold for active)
        UITabBarItem.appearance().setTitleTextAttributes([
            .font: customUIFont(.medium, size: 10, relativeTo: .caption2)
        ], for: .normal)
        
        UITabBarItem.appearance().setTitleTextAttributes([
            .font: customUIFont(.semiBold, size: 10, relativeTo: .caption2)
        ], for: .selected)
        
        // 5. Segmented Controls (Regular for normal, SemiBold for selected)
        UISegmentedControl.appearance().setTitleTextAttributes([
            .font: customUIFont(.regular, size: 13, relativeTo: .subheadline)
        ], for: .normal)
        
        UISegmentedControl.appearance().setTitleTextAttributes([
            .font: customUIFont(.semiBold, size: 13, relativeTo: .subheadline)
        ], for: .selected)
    }
}
