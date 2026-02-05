import SwiftUI

struct ExpenseRow: View {
    let expense: ExpenseEntity

    var body: some View {
        HStack(spacing: 12) {
            // Category icon
            Text(expense.category?.icon ?? "💸")
                .font(.system(size: 36))

            // Details
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(expense.category?.name ?? "Uncategorized")
                        .font(.body.weight(.medium))
                    Spacer()
                    Text(expense.amount.currencyFormatted)
                        .font(.body.weight(.semibold))
                }

                HStack {
                    Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if let comment = expense.comment, !comment.isEmpty {
                        Text("•")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(comment)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
