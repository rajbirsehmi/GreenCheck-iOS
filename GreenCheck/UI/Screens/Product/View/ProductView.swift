import SwiftUI
import SwiftData

struct ProductView: View {
    let product: ProductItem
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ProductViewModel?
    @State private var isFullIngredientListExpanded: Bool = false

    var body: some View {
        List {
            // Product Hero Header
            Section {
                VStack(spacing: 12) {
                    if let urlString = product.imageUrl, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(height: 160)
                    }

                    Text(product.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text(product.brand.uppercased())
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColors.onSurfaceVariant)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }

            // Vegan Status Banner
            Section("Status") {
                HStack(spacing: 12) {
                    Image(systemName: statusIcon(for: product.veganStatus))
                        .font(.title2)
                        .foregroundStyle(statusColor(for: product.veganStatus))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(statusTitle(for: product.veganStatus))
                            .font(.headline)
                        Text("UPC: \(product.id)")
                            .font(.caption)
                            .foregroundStyle(AppColors.onSurfaceVariant)
                    }
                }
                .padding(.vertical, 4)
            }

            // Alternate Suggestion Section (Only shown if status is NOT verified vegan)
            if product.veganStatus != .yes {
                Section("Vegan Alternatives") {
                    alternativesContent
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
            }

            // 1. Ingredient Analysis Section
            if !product.ingredients.isEmpty {
                Section("Ingredient Analysis") {
                    // 1a. Vegan Friendly
                    let veganItems = product.ingredients.filter { $0.vegan == .yes }
                    if !veganItems.isEmpty {
                        DisclosureGroup {
                            ForEach(veganItems) { ingredient in
                                IngredientAnalysisRow(ingredient: ingredient)
                            }
                        } label: {
                            HStack {
                                Label("Vegan Friendly (\(veganItems.count))", systemImage: "checkmark.seal.fill")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppColors.veganStatusGreen)
                            }
                        }
                    }

                    // 1b. Uncertain Source
                    let uncertainItems = product.ingredients.filter { $0.vegan == .maybe || $0.vegan == .unknown }
                    if !uncertainItems.isEmpty {
                        DisclosureGroup {
                            ForEach(uncertainItems) { ingredient in
                                IngredientAnalysisRow(ingredient: ingredient)
                            }
                        } label: {
                            HStack {
                                Label("Uncertain Source (\(uncertainItems.count))", systemImage: "exclamationmark.triangle.fill")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppColors.uncertainStatusYellow)
                            }
                        }
                    }

                    // 1c. Non-Vegan Detected
                    let nonVeganItems = product.ingredients.filter { $0.vegan == .no }
                    if !nonVeganItems.isEmpty {
                        DisclosureGroup {
                            ForEach(nonVeganItems) { ingredient in
                                IngredientAnalysisRow(ingredient: ingredient)
                            }
                        } label: {
                            HStack {
                                Label("Non-Vegan Detected (\(nonVeganItems.count))", systemImage: "xmark.octagon.fill")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(AppColors.nonVeganStatusRed)
                            }
                        }
                    }
                }

                // 2. Ingredient Breakdown Section
                Section("Ingredient Breakdown") {
                    ForEach(product.ingredients) { ingredient in
                        HStack {
                            Text(ingredient.name.capitalized)
                                .font(.body)

                            Spacer()

                            if let percent = ingredient.percentage {
                                Text(String(format: "%.1f%%", percent))
                                    .font(.subheadline)
                                    .monospacedDigit()
                                    .foregroundStyle(AppColors.onSurfaceVariant)
                            }

                            Image(systemName: statusIcon(for: ingredient.vegan))
                                .font(.footnote)
                                .foregroundStyle(statusColor(for: ingredient.vegan))
                        }
                    }
                }
            }

            // 3. Collapsible Full Ingredient List Section
            if !parsedIngredientsList.isEmpty {
                Section {
                    DisclosureGroup(isExpanded: $isFullIngredientListExpanded) {
                        ForEach(parsedIngredientsList, id: \.self) { ingredient in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(AppColors.primary)
                                    .frame(width: 5, height: 5)

                                Text(ingredient)
                                    .font(.subheadline)
                                    .foregroundStyle(AppColors.onBackground)
                            }
                            .padding(.vertical, 2)
                        }
                    } label: {
                        HStack {
                            Label("Full Ingredient List (\(parsedIngredientsList.count))", systemImage: "list.bullet.rectangle")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primary)
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel == nil {
                viewModel = ProductViewModel(context: modelContext)
            }
        }
    }
}

// MARK: - Subviews & Helpers
private extension ProductView {

    /// Parses comma-separated `ingredientsText` into clean, capitalized individual strings
    var parsedIngredientsList: [String] {
        guard !product.ingredientsText.isEmpty else { return [] }
        
        return product.ingredientsText
            .components(separatedBy: ",")
            .map { rawItem in
                let cleaned = rawItem.trimmingCharacters(in: .whitespacesAndNewlines)
                return cleaned.capitalized
            }
            .filter { !$0.isEmpty }
    }

    @ViewBuilder
    var alternativesContent: some View {
        if let viewModel = viewModel {
            if viewModel.isLoadingAlternatives {
                HStack {
                    Spacer()
                    ProgressView("Searching for alternatives...")
                        .font(.subheadline)
                    Spacer()
                }
                .padding(.vertical, 16)
            } else if !viewModel.alternativeProducts.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.alternativeProducts) { altProduct in
                            NavigationLink(destination: ProductView(product: altProduct)) {
                                AlternativeCard(product: altProduct)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                }
            } else if let errorMsg = viewModel.alternativeError {
                VStack(spacing: 8) {
                    Text(errorMsg)
                        .font(.footnote)
                        .foregroundStyle(AppColors.onSurfaceVariant)
                        .multilineTextAlignment(.center)

                    Button("Find Alternatives") {
                        Task {
                            await viewModel.fetchAlternatives(for: product)
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .buttonStyle(.borderedProminent)
                    .tint(AppColors.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            } else {
                Button {
                    Task {
                        await viewModel.fetchAlternatives(for: product)
                    }
                } label: {
                    HStack {
                        Spacer()
                        Label("Find Vegan Alternatives", systemImage: "sparkles")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    func statusColor(for status: DietaryStatus) -> Color {
        switch status {
        case .yes: return AppColors.veganStatusGreen
        case .no: return AppColors.nonVeganStatusRed
        case .maybe, .unknown: return AppColors.uncertainStatusYellow
        }
    }

    func statusIcon(for status: DietaryStatus) -> String {
        switch status {
        case .yes: return "checkmark.seal.fill"
        case .no: return "xmark.octagon.fill"
        case .maybe, .unknown: return "exclamationmark.triangle.fill"
        }
    }

    func statusTitle(for status: DietaryStatus) -> String {
        switch status {
        case .yes: return "Suitable for Vegans"
        case .no: return "Not Suitable for Vegans"
        case .maybe: return "May Contain Non-Vegan Ingredients"
        case .unknown: return "Vegan Status Unknown"
        }
    }
}

// MARK: - Ingredient Analysis Item Row
private struct IngredientAnalysisRow: View {
    let ingredient: IngredientItem

    var body: some View {
        HStack {
            Text(ingredient.name.capitalized)
                .font(.subheadline)

            Spacer()

            if let percent = ingredient.percentage {
                Text(String(format: "%.1f%%", percent))
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - HIG Alternative Carousel Card Component
struct AlternativeCard: View {
    let product: ProductItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                AppShapes.small
                    .fill(Color(uiColor: .tertiarySystemGroupedBackground))

                if let urlString = product.imageUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .padding(6)
                        } else {
                            Image(systemName: "leaf.fill")
                                .foregroundStyle(AppColors.primary)
                        }
                    }
                } else {
                    Image(systemName: "leaf.fill")
                        .foregroundStyle(AppColors.primary)
                }
            }
            .frame(width: 120, height: 100)

            VStack(alignment: .leading, spacing: 2) {
                Text(product.brand.uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.primary)

                Text(product.name)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppColors.onBackground)
                    .lineLimit(2)

                HStack(spacing: 4) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.caption2)
                        .foregroundStyle(AppColors.veganStatusGreen)
                    Text("Vegan")
                        .font(.caption2)
                        .foregroundStyle(AppColors.veganStatusGreen)
                }
            }
            .frame(width: 120, alignment: .leading)
        }
        .padding(8)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(AppShapes.medium)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}
