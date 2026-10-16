//
//  Utils.swift
//  GreenCheck
//
//  Created by Rajbir Singh Sehmi on 10/6/26.
//

import Foundation

extension String {
    func normalizedBarcode() -> String {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.count < 14 {
            return String(repeating: "0", count: 14 - trimmed.count) + trimmed
        }
        return trimmed
    }
}
