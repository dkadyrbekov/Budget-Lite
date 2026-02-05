import Foundation
import SwiftData

@Model
final class CategoryEntity {
    var id: UUID
    var name: String
    var icon: String
    var createdAt: Date
    var sortOrder: Int

    @Relationship(deleteRule: .nullify, inverse: \ExpenseEntity.category)
    var expenses: [ExpenseEntity]?

    init(name: String, icon: String = "💸", sortOrder: Int = 0) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.createdAt = Date()
        self.sortOrder = sortOrder
        self.expenses = []
    }

    var hasExpenses: Bool {
        return (expenses?.isEmpty == false)
    }
}
