//
//  ProductLocalDataSourceProtocol.swift
//  GreenCheck
//
//  Created by Rajbir Singh Sehmi on 10/6/26.
//

import Foundation

protocol ProductLocalDataSource {
    func getCachedProduct(byBarcode barcode: String) async -> ProductItem?
    func getAllCachedProducts() async -> [ProductItem]
    func isProductCached(byBarcode barcode: String) async -> Bool
    func saveProduct(_ product: ProductItem) async throws
    func deleteProduct(byBarcode barcode: String) async throws
    func clearAllHistory() async throws
}
