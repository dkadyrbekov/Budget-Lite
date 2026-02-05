import SwiftUI
import SwiftData

struct StatsTab: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var monthStore: MonthStore
    @Query private var allExpenses: [ExpenseEntity]
    @Query(sort: \CategoryEntity.sortOrder) private var categories: [CategoryEntity]
    @State private var showingAddExpense = false

    private var filteredExpenses: [ExpenseEntity] {
        allExpenses.filter { expense in
            Calendar.current.isDate(expense.date, equalTo: monthStore.selectedDate, toGranularity: .month)
        }
    }

    private var totalSpent: Decimal {
        filteredExpenses.reduce(Decimal(0)) { $0 + $1.amount }
    }

    private var categoryStats: [(category: CategoryEntity, amount: Decimal, percentage: Double)] {
        var stats: [CategoryEntity: Decimal] = [:]

        for expense in filteredExpenses {
            if let category = expense.category {
                stats[category, default: 0] += expense.amount
            }
        }

        let total = Double(truncating: totalSpent as NSNumber)

        return stats.map { (category, amount) in
            let percentage = total > 0 ? (Double(truncating: amount as NSNumber) / total * 100) : 0
            return (category, amount, percentage)
        }.sorted { $0.amount > $1.amount }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                MonthNavigator()

                if filteredExpenses.isEmpty {
                    emptyState
                } else {
                    statsContent
                }
            }
            .navigationTitle("Statistics")
            .sheet(isPresented: $showingAddExpense) {
                AddExpenseSheet()
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.pie")
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

    private var statsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Total
                VStack(spacing: 8) {
                    Text("Total Spent")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(totalSpent.currencyFormatted)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                }
                .padding(.top, 20)

                // Donut Chart
                if !categoryStats.isEmpty {
                    DonutChart(categoryStats: categoryStats)
                        .frame(height: 250)
                        .padding(.horizontal)
                }

                // Category Breakdown
                VStack(alignment: .leading, spacing: 12) {
                    Text("By Category")
                        .font(.headline)
                        .padding(.horizontal)

                    ForEach(categoryStats, id: \.category.id) { stat in
                        HStack {
                            Text(stat.category.icon)
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(stat.category.name)
                                    .font(.body)
                                Text("\(stat.percentage, specifier: "%.1f")%")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(stat.amount.currencyFormatted)
                                .font(.body.weight(.semibold))
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}
