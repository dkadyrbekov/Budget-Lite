import SwiftUI
import SwiftData

struct CategoriesTab: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\CategoryEntity.sortOrder), SortDescriptor(\CategoryEntity.createdAt)])
    private var categories: [CategoryEntity]
    @State private var showingAddCategory = false
    @State private var categoryToEdit: CategoryEntity?
    @State private var showingDeleteAlert = false
    @State private var categoryToDelete: CategoryEntity?

    var body: some View {
        NavigationStack {
            List {
                ForEach(categories) { category in
                    HStack {
                        Text(category.icon)
                            .font(.title2)
                        Text(category.name)
                            .font(.body)
                        Spacer()
                        if let expenseCount = category.expenses?.count, expenseCount > 0 {
                            Text("\(expenseCount)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        categoryToEdit = category
                    }
                }
                .onDelete(perform: deleteCategory)
                .onMove(perform: moveCategory)
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddCategory = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddCategory) {
                AddCategorySheet()
            }
            .sheet(item: $categoryToEdit) { category in
                EditCategorySheet(category: category)
            }
            .alert("Cannot Delete Category", isPresented: $showingDeleteAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("This category has expenses. Delete or move expenses first.")
            }
        }
    }

    private func deleteCategory(at offsets: IndexSet) {
        for index in offsets {
            let category = categories[index]
            if category.hasExpenses {
                categoryToDelete = category
                showingDeleteAlert = true
            } else {
                modelContext.delete(category)
            }
        }
    }

    private func moveCategory(from source: IndexSet, to destination: Int) {
        var reorderedCategories = categories
        reorderedCategories.move(fromOffsets: source, toOffset: destination)

        for (index, category) in reorderedCategories.enumerated() {
            category.sortOrder = index
        }
    }
}
