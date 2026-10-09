import SwiftUI
import SwiftData

struct ManualView: View {
    @Binding var selectedTab: Int
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: ManualViewModel?
    @State private var barcode: String = ""
    @State private var showQuotaAlert = false
    @FocusState private var isFieldFocused: Bool
    private let quotaManager = QuotaManager.shared

    var body: some View {
        Form {
            Section {
                HStack {
                    QuotaBadgeView(
                        current: quotaManager.manualCount,
                        limit: quotaManager.dailyLimit,
                        icon: "keyboard"
                    )
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

                HStack {
                    Image(systemName: "barcode")
                        .foregroundStyle(AppColors.onSurfaceVariant)

                    TextField("Enter Barcode Number", text: $barcode)
                        .keyboardType(.numberPad)
                        .focused($isFieldFocused)
                        .onChange(of: barcode) { _, newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            barcode = String(filtered.prefix(14))
                        }

                    if !barcode.isEmpty {
                        Button {
                            barcode = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(AppColors.onSurfaceVariant)
                        }
                        .buttonStyle(.plain)
                    }
                }
            } footer: {
                Text("Supports standard EAN-13, EAN-8, and UPC barcodes.")
            }

            Section {
                Button(action: submitSearch) {
                    HStack {
                        Spacer()
                        if viewModel?.isLoading == true {
                            ProgressView()
                        } else {
                            Text("Search Product")
                                .fontWeight(.semibold)
                        }
                        Spacer()
                    }
                }
                .disabled(barcode.trimmingCharacters(in: .whitespaces).isEmpty || (viewModel?.isLoading ?? false))
            }
        }
        .onAppear {
            if !quotaManager.canManualSearch {
                showQuotaAlert = true
            } else {
                if viewModel == nil {
                    viewModel = ManualViewModel(context: modelContext)
                }
            }
        }
        .navigationDestination(item: Binding(
            get: { viewModel?.product },
            set: { viewModel?.product = $0 }
        )) { product in
            ProductView(product: product)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { isFieldFocused = false }
            }
        }
        .alert("Quota Depleted for Today", isPresented: $showQuotaAlert) {
            Button("OK", role: .cancel) {
                selectedTab = 0 // Navigate back to Home
            }
        } message: {
            Text("You've reached your daily limit of 10 manual lookups. Your limit will refresh tonight at midnight.")
        }
        .alert("Product Not Found", isPresented: Binding(
            get: { viewModel?.showErrorAlert ?? false },
            set: { viewModel?.showErrorAlert = $0 }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel?.errorMessage ?? "Could not locate product details for this barcode.")
        }
    }

    private func submitSearch() {
        let trimmed = barcode.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        isFieldFocused = false
        Task { await viewModel?.fetchProduct(from: trimmed) }
    }
}
