# Budget Lite 💸

A beautifully simple, fully offline personal expense tracker for iPhone.

## ✨ Features

- ⚡ **Ultra-fast expense entry** - Optimized for one-handed use (amount → category → save)
- 📊 **Monthly statistics** - Pure SwiftUI donut chart with category breakdown
- 🗂️ **Smart categories** - Drag-to-reorder, emoji icons, delete protection
- 📱 **iPhone-only** - iOS 26.0+, native SwiftUI
- 🔒 **100% offline** - No servers, accounts, sync, or analytics
- 💾 **SwiftData persistence** - Local database with Decimal precision (no floating-point errors)

## 🚀 Quick Start

1. **Open Xcode** and create a new iOS App project named "BudgetLite"
2. **Set deployment target** to iOS 26.0 (iPhone only)
3. **Delete** auto-generated `BudgetLiteApp.swift` and `ContentView.swift`
4. **Drag** the entire `BudgetLite/` folder from this repo into Xcode
5. **Build and run** (⌘+R)

📖 **Detailed instructions:** See [SETUP.md](SETUP.md)

## 📂 What's Included

```
BudgetLite/
├── Models/          SwiftData entities (Category, Expense)
├── Stores/          Shared state (MonthStore)
├── Views/
│   ├── Tabs/        Main screens (Expenses, Stats, Categories)
│   ├── Sheets/      Add/Edit modals
│   └── Components/  Reusable UI (DonutChart, EmojiPicker, etc.)
└── Helpers/         Extensions and utilities
```

🏗️ **Architecture details:** See [ARCHITECTURE.md](ARCHITECTURE.md)

## 🎯 Core Philosophy

**No scope creep.** This is an MVP expense tracker with:
- ✅ Categories (CRUD + manual ordering)
- ✅ Expenses (CRUD with Decimal amounts)
- ✅ Monthly stats (total + donut chart)

**Not included** (by design):
- ❌ Cloud sync / accounts
- ❌ Budgets / limits / alerts
- ❌ Income tracking
- ❌ Recurring expenses
- ❌ Export / import
- ❌ Search / filters
- ❌ Subscriptions / paywalls
- ❌ Analytics / tracking

## 🛠️ Tech Stack

- **Language:** Swift (latest stable)
- **UI:** SwiftUI
- **Data:** SwiftData (local only)
- **Target:** iOS 26.0+
- **Dependencies:** Zero (system frameworks only)

## 📸 Key Screens

### Expenses Tab
- List of expenses for selected month (sorted by date)
- Fast add with "+" button
- Swipe to delete

### Stats Tab
- Monthly total spending
- Pure SwiftUI donut chart (no third-party libs)
- Category breakdown with percentages

### Categories Tab
- Reorderable list (drag to change order)
- Add/edit categories with emoji picker
- Delete protection (blocks if category has expenses)

## 🎨 Design Highlights

- **Large tap targets** - Easy one-handed operation
- **Big emojis** - Category icons at 36-40pt for quick recognition
- **Minimal friction** - Amount + category = saved (2 taps)
- **Auto Dark Mode** - Uses system colors throughout
- **Native feel** - System fonts, standard components, familiar patterns

## 🧪 Technical Highlights

### Decimal Precision
Avoids floating-point errors by storing amounts as `String`, exposing as `Decimal`:
```swift
var amountString: String  // Stored in database
var amount: Decimal       // Computed property for calculations
```

### Manual Category Ordering
Uses `sortOrder: Int` field, updated via drag-to-reorder:
```swift
@Query(sort: [SortDescriptor(\CategoryEntity.sortOrder)])
```

### Shared Month State
`MonthStore` (@EnvironmentObject) keeps Expenses + Stats in sync:
```swift
@EnvironmentObject private var monthStore: MonthStore
```

### Pure SwiftUI Donut Chart
Built with `Path` and `addArc` - no external chart libraries needed.

## 📝 License

This is a sample project for demonstration purposes. Use freely!

## 🤝 Contributing

This is a complete, self-contained MVP. No contributions needed - it's ready to use as-is or fork for your own modifications.

---

**Built by a senior iOS engineer with love for clean code.** 🚀
