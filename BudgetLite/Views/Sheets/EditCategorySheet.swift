import SwiftUI
import SwiftData

struct EditCategorySheet: View {
    @Environment(\.dismiss) private var dismiss

    let category: CategoryEntity

    @State private var name = ""
    @State private var selectedIcon = ""
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
            .navigationTitle("Edit Category")
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
            .onAppear {
                name = category.name
                selectedIcon = category.icon
            }
        }
    }

    private func saveCategory() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        category.name = trimmedName
        category.icon = selectedIcon
        dismiss()
    }
}
