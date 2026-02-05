import SwiftUI
import SwiftData

struct AddExpenseSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var monthStore: MonthStore
    @Query(sort: [SortDescriptor(\CategoryEntity.sortOrder), SortDescriptor(\CategoryEntity.createdAt)])
    private var categories: [CategoryEntity]

    @State private var amountText = ""
    @State private var selectedCategory: CategoryEntity?
    @State private var showCommentField = false
    @State private var comment = ""
    @FocusState private var amountFieldFocused: Bool

    private var amount: Decimal? {
        Decimal(string: amountText)
    }

    private var isValid: Bool {
        if let amount = amount, amount > 0, selectedCategory != nil {
            return true
        }
        return false
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Amount field
                VStack(spacing: 8) {
                    Text("Amount")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    HStack {
                        Text("$")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundStyle(.secondary)
                        TextField("0.00", text: $amountText)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .keyboardType(.decimalPad)
                            .focused($amountFieldFocused)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)

                Text("Today: \(Date().formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 20)

                Divider()

                // Category selection
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Category")
                            .font(.headline)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)

                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(categories) { category in
                                CategoryTile(
                                    category: category,
                                    isSelected: selectedCategory?.id == category.id
                                )
                                .onTapGesture {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        // Optional comment
                        if showCommentField {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comment (optional)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                TextField("Add a note", text: $comment)
                                    .textFieldStyle(.roundedBorder)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        } else {
                            Button {
                                showCommentField = true
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle")
                                    Text("Add comment")
                                }
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 8)
                        }
                    }
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    saveExpense()
                } label: {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isValid ? Color.accentColor : Color.gray.opacity(0.3))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(!isValid)
                .padding()
                .background(.regularMaterial)
            }
            .onAppear {
                amountFieldFocused = true
            }
        }
    }

    private func saveExpense() {
        guard let amount = amount, amount > 0, let category = selectedCategory else {
            return
        }

        let expense = ExpenseEntity(
            amount: amount,
            date: monthStore.selectedDate,
            category: category,
            comment: comment.isEmpty ? nil : comment
        )

        modelContext.insert(expense)

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        dismiss()
    }
}
