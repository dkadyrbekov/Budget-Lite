import SwiftUI
import SwiftData

@main
struct BudgetLiteApp: App {
    let modelContainer: ModelContainer
    @StateObject private var monthStore = MonthStore()

    init() {
        do {
            let schema = Schema([
                CategoryEntity.self,
                ExpenseEntity.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

            // Seed default categories on first launch
            DataSeeder.seedIfNeeded(modelContext: modelContainer.mainContext)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
                .environmentObject(monthStore)
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            ExpensesTab()
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet.rectangle")
                }

            StatsTab()
                .tabItem {
                    Label("Stats", systemImage: "chart.pie")
                }

            CategoriesTab()
                .tabItem {
                    Label("Categories", systemImage: "folder")
                }
        }
    }
}
