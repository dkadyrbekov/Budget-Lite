import SwiftUI
import SwiftData

struct ExpensesTab: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var monthStore: MonthStore
    @Query private var allExpenses: [ExpenseEntity]
    @State private var showingAddExpense = false
    @State private var expenseToEdit: ExpenseEntity?

    private var filteredExpenses: [ExpenseEntity] {
        allExpenses.filter { expense in
            Calendar.current.isDate(expense.date, equalTo: monthStore.selectedDate, toGranularity: .month)
        }.sorted { first, second in
            if first.date != second.date {
                return first.date > second.date
            }
            return first.createdAt > second.createdAt
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                MonthNavigator()

                if filteredExpenses.isEmpty {
                    emptyState
                } else {
                    expensesList
                }
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3.weight(.semibold))
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseSheet()
            }
            .sheet(item: $expenseToEdit) { expense in
                EditExpenseSheet(expense: expense)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            Text("No expenses this month")
                .font(.title3)
                .foregroundStyle(.secondary)
            Button {
                showingAddExpense = true
            } label: {
                Label("Add Expense", systemImage: "plus.circle.fill")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var expensesList: some View {
        List {
            ForEach(filteredExpenses) { expense in
                ExpenseRow(expense: expense)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        expenseToEdit = expense
                    }
            }
            .onDelete(perform: deleteExpenses)
        }
        .listStyle(.plain)
    }

    private func deleteExpenses(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(filteredExpenses[index])
        }
    }
}
