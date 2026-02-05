import SwiftUI
import SwiftData

struct EditExpenseSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: [SortDescriptor(\CategoryEntity.sortOrder), SortDescriptor(\CategoryEntity.createdAt)])
    private var categories: [CategoryEntity]

    let expense: ExpenseEntity

    @State private var amountText = ""
    @State private var selectedCategory: CategoryEntity?
    @State private var date: Date
    @State private var comment: String

    init(expense: ExpenseEntity) {
        self.expense = expense
        _date = State(initialValue: expense.date)
        _comment = State(initialValue: expense.comment ?? "")
    }

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
            Form {
                Section("Amount") {
                    HStack {
                        Text("$")
                            .foregroundStyle(.secondary)
                        TextField("0.00", text: $amountText)
                            .keyboardType(.decimalPad)
                            .font(.title2.weight(.semibold))
                    }
                }

                Section("Date") {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }

                Section("Category") {
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
                    .padding(.vertical, 8)
                }

                Section("Comment (optional)") {
                    TextField("Add a note", text: $comment, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Edit Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveExpense()
                    }
                    .disabled(!isValid)
                }
            }
            .onAppear {
                amountText = expense.amount.description
                selectedCategory = expense.category
            }
        }
    }

    private func saveExpense() {
        guard let amount = amount, amount > 0, let category = selectedCategory else {
            return
        }

        expense.amount = amount
        expense.date = date
        expense.category = category
        expense.comment = comment.isEmpty ? nil : comment

        dismiss()
    }
}
