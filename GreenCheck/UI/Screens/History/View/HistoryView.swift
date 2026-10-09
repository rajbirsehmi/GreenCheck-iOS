import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: HistoryViewModel?
    @State private var showClearAlert = false

    var body: some View {
        Group {
            if let viewModel = viewModel {
                if viewModel.historyItems.isEmpty {
                    ContentUnavailableView(
                        "No Scan History",
                        systemImage: "clock",
                        description: Text("Products you search or scan will appear here.")
                    )
                } else {
                    List {
                        Section {
                            Picker("Filter", selection: Binding(
                                get: { viewModel.selectedFilter },
                                set: { viewModel.selectedFilter = $0 }
                            )) {
                                ForEach(HistoryViewModel.VeganFilter.allCases) { filter in
                                    Text(filter.rawValue).tag(filter)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())

                        Section {
                            ForEach(viewModel.filteredItems) { product in
                                NavigationLink(destination: ProductView(product: product)) {
                                    HistoryRowCell(product: product)
                                }
                            }
                            .onDelete { offsets in
                                Task { await viewModel.deleteItem(at: offsets) }
                            }
                        }

                        Section {
                            Button(role: .destructive) {
                                showClearAlert = true
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Clear History")
                                    Spacer()
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
        }
        .searchable(
            text: Binding(
                get: { viewModel?.searchText ?? "" },
                set: { viewModel?.searchText = $0 }
            ),
            prompt: "Search History"
        )
        .alert("Clear Scan History?", isPresented: $showClearAlert) {
            Button("Clear All", role: .destructive) {
                Task { await viewModel?.clearAll() }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone.")
        }
        .onAppear {
            if viewModel == nil { viewModel = HistoryViewModel(context: modelContext) }
            Task { await viewModel?.fetchHistory() }
        }
    }
}

struct HistoryRowCell: View {
    let product: ProductItem

    var body: some View {
        HStack(spacing: 12) {
            if let urlString = product.imageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Image(systemName: "leaf.fill").foregroundStyle(AppColors.primary)
                }
                .frame(width: 40, height: 40)
                .clipShape(AppShapes.small)
            } else {
                Image(systemName: "leaf.fill")
                    .frame(width: 40, height: 40)
                    .foregroundStyle(AppColors.primary)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(product.name)
                    .font(.body)
                    .foregroundStyle(AppColors.onBackground)
                    .lineLimit(1)

                Text(product.brand)
                    .font(.caption)
                    .foregroundStyle(AppColors.onSurfaceVariant)
            }

            Spacer()

            Image(systemName: statusIcon(for: product.veganStatus))
                .foregroundStyle(statusColor(for: product.veganStatus))
        }
    }

    private func statusColor(for status: DietaryStatus) -> Color {
        switch status {
        case .yes: return AppColors.veganStatusGreen
        case .no: return AppColors.nonVeganStatusRed
        case .maybe, .unknown: return AppColors.uncertainStatusYellow
        }
    }

    private func statusIcon(for status: DietaryStatus) -> String {
        switch status {
        case .yes: return "checkmark.circle.fill"
        case .no: return "xmark.circle.fill"
        case .maybe, .unknown: return "exclamationmark.triangle.fill"
        }
    }
}
