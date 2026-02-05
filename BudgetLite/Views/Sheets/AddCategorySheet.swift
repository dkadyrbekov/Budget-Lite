import SwiftUI
import SwiftData

struct AddCategorySheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \CategoryEntity.sortOrder) private var categories: [CategoryEntity]

    @State private var name = ""
    @State private var selectedIcon = "💸"
    @State private var showingEmojiPicker = false

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Category Name") {
                    TextField("e.g., Groceries", text: $name)
                        .autocorrectionDisabled()
                }

                Section("Icon") {
                    HStack {
                        Text("Selected:")
                            .foregroundStyle(.secondary)
                        Text(selectedIcon)
                            .font(.system(size: 40))
                        Spacer()
                        Button("Change") {
                            showingEmojiPicker.toggle()
                        }
                    }

                    if showingEmojiPicker {
                        EmojiPicker(selectedEmoji: $selectedIcon)
                    }
                }
            }
            .navigationTitle("New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategory()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private func saveCategory() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        let maxSortOrder = categories.map(\.sortOrder).max() ?? -1
        let category = CategoryEntity(
            name: trimmedName,
            icon: selectedIcon,
            sortOrder: maxSortOrder + 1
        )

        modelContext.insert(category)
        dismiss()
    }
}
