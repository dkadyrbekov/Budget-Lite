import Foundation
import SwiftData

struct DataSeeder {
    static func seedIfNeeded(modelContext: ModelContext) {
        let fetchDescriptor = FetchDescriptor<CategoryEntity>()

        do {
            let existingCategories = try modelContext.fetch(fetchDescriptor)

            if existingCategories.isEmpty {
                // Create default categories
                let defaultCategories = [
                    CategoryEntity(name: "Food", icon: "🍔", sortOrder: 0),
                    CategoryEntity(name: "Transport", icon: "🚗", sortOrder: 1),
                    CategoryEntity(name: "Home", icon: "🏠", sortOrder: 2),
                    CategoryEntity(name: "Fun", icon: "🎮", sortOrder: 3)
                ]

                for category in defaultCategories {
                    modelContext.insert(category)
                }

                try modelContext.save()
            }
        } catch {
            print("Failed to seed data: \(error)")
        }
    }
}
