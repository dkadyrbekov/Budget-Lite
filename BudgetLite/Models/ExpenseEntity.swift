import Foundation
import SwiftData

@Model
final class ExpenseEntity {
    var id: UUID
    var amountString: String // Store Decimal as String to avoid floating-point issues
    var date: Date
    var comment: String?
    var createdAt: Date

    @Relationship(deleteRule: .nullify)
    var category: CategoryEntity?

    init(amount: Decimal, date: Date, category: CategoryEntity?, comment: String? = nil) {
        self.id = UUID()
        self.amountString = NSDecimalNumber(decimal: amount).stringValue
        self.date = date
        self.category = category
        self.comment = comment
        self.createdAt = Date()
    }

    var amount: Decimal {
        get {
            return Decimal(string: amountString) ?? 0
        }
        set {
            amountString = NSDecimalNumber(decimal: newValue).stringValue
        }
    }
}
