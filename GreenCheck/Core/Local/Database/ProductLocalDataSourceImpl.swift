// Core/Local/Database/ProductLocalDataSourceImpl.swift
import Foundation
import SwiftData

@MainActor
final class ProductLocalDataSourceImpl: ProductLocalDataSource {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func getCachedProduct(byBarcode barcode: String) async -> ProductItem? {
        do {
            var descriptor = FetchDescriptor<ProductEntity>(
                predicate: #Predicate { $0.id == barcode },
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            descriptor.fetchLimit = 1
            if let entity = try context.fetch(descriptor).first {
                return entity.toDomain()
            }
        } catch {
            print("❌ SwiftData Fetch Error: \(error)")
        }
        return nil
    }

    func getAllCachedProducts() async -> [ProductItem] {
        do {
            let descriptor = FetchDescriptor<ProductEntity>(
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            let entities = try context.fetch(descriptor)
            return entities.map { $0.toDomain() }
        } catch {
            print("❌ SwiftData Fetch All Error: \(error)")
            return []
        }
    }
    
    func isProductCached(byBarcode barcode: String) async -> Bool {
        do {
            let descriptor = FetchDescriptor<ProductEntity>(
                predicate: #Predicate { $0.id == barcode }
            )
            return try context.fetchCount(descriptor) > 0
        } catch {
            print("❌ SwiftData Count Error: \(error)")
            return false
        }
    }
    
    func saveProduct(_ product: ProductItem) async throws {
        do {
            let descriptor = FetchDescriptor<ProductEntity>(
                predicate: #Predicate { $0.id == product.id }
            )
            
            let ingredientsData = try JSONEncoder().encode(product.ingredients)
            
            if let existing = try context.fetch(descriptor).first {
                existing.name = product.name
                existing.brand = product.brand
                existing.imageUrl = product.imageUrl
                existing.ingredientsText = product.ingredientsText
                existing.analysisTags = product.analysisTags
                existing.ingredientsData = ingredientsData
                existing.createdAt = .now
            } else {
                let entity = ProductEntity(from: product)
                entity.ingredientsData = ingredientsData
                context.insert(entity)
            }
            
            try context.save()
        } catch {
            print("❌ SwiftData Save Failed: \(error.localizedDescription)")
            throw error
        }
    }

    func deleteProduct(byBarcode barcode: String) async throws {
        do {
            let descriptor = FetchDescriptor<ProductEntity>(
                predicate: #Predicate { $0.id == barcode }
            )
            if let entity = try context.fetch(descriptor).first {
                context.delete(entity)
                try context.save()
            }
        } catch {
            print("❌ SwiftData Delete Failed: \(error.localizedDescription)")
            throw error
        }
    }

    func clearAllHistory() async throws {
        do {
            try context.delete(model: ProductEntity.self)
            try context.save()
        } catch {
            print("❌ SwiftData Clear All Failed: \(error.localizedDescription)")
            throw error
        }
    }
}
