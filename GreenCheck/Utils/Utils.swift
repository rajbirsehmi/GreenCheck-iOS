//
//  Utils.swift
//  GreenCheck
//
//  Created by Rajbir Singh Sehmi on 10/6/26.
//

import Foundation

struct Utils {
    
    private var appId: UUID
    
    mutating func setAppUUID() {
        appId = UUID()
    }
    
    func getAppUUID() -> String {
        return appId.uuidString
    }
}
