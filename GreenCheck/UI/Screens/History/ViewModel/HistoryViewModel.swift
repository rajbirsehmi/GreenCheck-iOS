// UI/Screens/History/ViewModel/HistoryViewModel.swift
import Foundation
import SwiftData
import Observation

@Observable
final class HistoryViewModel {
    private let repo: ProductRepository
    
    var historyItems: [ProductItem] = []
    var searchText: String = ""
    var isLoading: Bool = false
    var selectedFilter: VeganFilter = .all
    
    enum VeganFilter: String, CaseIterable, Identifiable {
        case all = "All"
        case vegan = "Vegan"
        case nonVegan = "Non-Vegan"
        
        var id: String { rawValue }
    }

    init(context: ModelContext) {
        let localDS = ProductLocalDataSourceImpl(context: context)
        self.repo = ProductRepositoryImpl(localDataSource: localDS)
    }
    
    init(repo: ProductRepository) {
        self.repo = repo
    }

    var filteredItems: [ProductItem] {
        historyItems.filter { item in
            let matchesSearch = searchText.isEmpty ||
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.brand.localizedCaseInsensitiveContains(searchText) ||
                item.id.contains(searchText)
            
            switch selectedFilter {
            case .all:
                return matchesSearch
            case .vegan:
                return matchesSearch && item.veganStatus == .yes
            case .nonVegan:
                return matchesSearch && item.veganStatus == .no
            }
        }
    }

    @MainActor
    func fetchHistory() async {
        isLoading = true
        historyItems = await repo.getAllCachedProducts()
        isLoading = false
    }

    @MainActor
    func deleteItem(at offsets: IndexSet) async {
        for index in offsets {
            let item = filteredItems[index]
            try? await repo.deleteProduct(byBarcode: item.id)
        }
        await fetchHistory()
    }

    @MainActor
    func clearAll() async {
        try? await repo.clearAllHistory()
        historyItems.removeAll()
    }
}
