# Budget Lite - Architecture & Technical Details

## Complete File Structure

```
BudgetLite/
│
├── BudgetLiteApp.swift                 # App entry point, SwiftData setup, tab navigation
│
├── Models/
│   ├── CategoryEntity.swift            # @Model: id, name, icon, sortOrder, expenses[]
│   └── ExpenseEntity.swift             # @Model: id, amount (Decimal), date, category, comment
│
├── Stores/
│   └── MonthStore.swift                # @ObservableObject: shared month selection state
│
├── Views/
│   ├── Tabs/
│   │   ├── ExpensesTab.swift           # Main list + add button, filtered by month
│   │   ├── StatsTab.swift              # Total + donut chart + category breakdown
│   │   └── CategoriesTab.swift         # Reorderable list with drag-to-reorder
│   │
│   ├── Sheets/
│   │   ├── AddExpenseSheet.swift       # Fast entry: amount + category grid + save
│   │   ├── EditExpenseSheet.swift      # Full editing with date picker
│   │   ├── AddCategorySheet.swift      # Create category: name + emoji
│   │   └── EditCategorySheet.swift     # Edit category: rename + change icon
│   │
│   └── Components/
│       ├── DonutChart.swift            # Pure SwiftUI Path-based donut chart
│       ├── EmojiPicker.swift           # Grid of common emojis + custom input
│       ├── CategoryTile.swift          # Large tappable category card (emoji + name)
│       ├── ExpenseRow.swift            # List row: icon, category, amount, date, comment
│       └── MonthNavigator.swift        # Previous/next month navigation bar
│
└── Helpers/
    ├── DecimalExtensions.swift         # Currency formatting for Decimal
    ├── DateExtensions.swift            # Calendar helpers (startOfMonth, endOfMonth)
    └── DataSeeder.swift                # First-launch default categories seeding
```

## Data Flow

### SwiftData Models

**CategoryEntity**
```swift
- id: UUID
- name: String
- icon: String (emoji)
- createdAt: Date
- sortOrder: Int (for manual ordering)
- expenses: [ExpenseEntity]? (one-to-many)
```

**ExpenseEntity**
```swift
- id: UUID
- amountString: String (stores Decimal as String)
- amount: Decimal (computed property, converts to/from String)
- date: Date
- comment: String?
- createdAt: Date
- category: CategoryEntity? (many-to-one)
```

### State Management

1. **SwiftData Queries** (in views):
   ```swift
   @Query private var categories: [CategoryEntity]
   @Query private var allExpenses: [ExpenseEntity]
   ```

2. **MonthStore** (shared via EnvironmentObject):
   ```swift
   @Published var selectedDate: Date
   var monthStart: Date
   var monthEnd: Date
   func previousMonth()
   func nextMonth()
   ```

3. **Local @State** for sheet presentation and form inputs

### Navigation Structure

```
TabView
├── ExpensesTab
│   ├── List (filtered by month)
│   └── Sheet: AddExpenseSheet / EditExpenseSheet
│
├── StatsTab
│   ├── DonutChart
│   ├── Total amount
│   └── Category breakdown list
│
└── CategoriesTab
    ├── Reorderable List
    └── Sheet: AddCategorySheet / EditCategorySheet
```

## Key Technical Decisions

### 1. Decimal for Money (No Float/Double)
**Problem:** Floating-point arithmetic causes rounding errors
**Solution:** Store amounts as `String`, expose as `Decimal`

```swift
var amountString: String  // "19.99"
var amount: Decimal {     // Computed property
    get { Decimal(string: amountString) ?? 0 }
    set { amountString = NSDecimalNumber(decimal: newValue).stringValue }
}
```

### 2. Manual Category Ordering
**Problem:** Need user-defined order (not alphabetical or by date)
**Solution:** `sortOrder: Int` field, updated on drag-to-reorder

```swift
func moveCategory(from source: IndexSet, to destination: Int) {
    var reordered = categories
    reordered.move(fromOffsets: source, toOffset: destination)
    for (index, category) in reordered.enumerated() {
        category.sortOrder = index
    }
}
```

### 3. Month Filtering (Shared State)
**Problem:** Expenses + Stats must show same month
**Solution:** `MonthStore` as `@EnvironmentObject`

```swift
@EnvironmentObject private var monthStore: MonthStore

var filtered = allExpenses.filter { expense in
    Calendar.current.isDate(expense.date, equalTo: monthStore.selectedDate, toGranularity: .month)
}
```

### 4. Pure SwiftUI Donut Chart
**Problem:** No third-party dependencies allowed
**Solution:** Custom `Path` + `StrokeStyle`

```swift
Path { path in
    path.addArc(
        center: center,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
        clockwise: false
    )
}
.stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
```

### 5. Delete Protection for Categories
**Problem:** Prevent orphaned expenses
**Solution:** Check `category.hasExpenses` before delete

```swift
if category.hasExpenses {
    showingDeleteAlert = true  // "Delete expenses first"
} else {
    modelContext.delete(category)
}
```

### 6. Fast Expense Entry UX
**Optimization:** Minimize taps and maximize thumb-reachability

- Auto-focus amount field on sheet open
- Numeric keyboard (no manual switch)
- Large category tiles (3-column grid, 40pt emoji)
- Date defaults to today (no picker in add flow)
- Comment collapsed by default
- Big "Save" button at bottom
- Haptic feedback on success

## Performance Considerations

### SwiftData Queries
- Use `@Query` for reactive updates
- Sort at query level: `@Query(sort: \CategoryEntity.sortOrder)`
- Filter in computed properties (not queries) for dynamic month selection

### List Rendering
- `LazyVGrid` for category tiles (lazy loading)
- Native `List` for expenses (optimized scrolling)
- Minimal view hierarchy depth

### Data Persistence
- SwiftData auto-saves on context changes
- No manual `save()` calls needed (except in DataSeeder)
- Background context not needed (app is simple, no long operations)

## UX Patterns

### Progressive Disclosure
- Comment field hidden by default (tap "Add comment" to reveal)
- Emoji picker collapsed until "Change" tapped
- Edit mode for category reordering (Edit button)

### Visual Hierarchy
1. **Primary:** Amount (48pt bold), Category emoji (36-40pt)
2. **Secondary:** Category name, date
3. **Tertiary:** Comment, percentage

### One-Handed Optimization
- Bottom-sheet save button (thumb-friendly)
- Large tap targets (min 44pt)
- Grid layout for categories (not scrolling list)

## Extensibility Points

Want to add features later? Here are the clean extension points:

1. **Export/Import:** Add methods to `CategoryEntity`/`ExpenseEntity` for JSON serialization
2. **Search:** Add `@State var searchText` in `ExpensesTab`, filter by comment/category
3. **Budgets:** Add `budget: Decimal?` to `CategoryEntity`, show warning in `StatsTab`
4. **Recurring Expenses:** New `RecurringExpenseEntity` model with `frequency` field
5. **Multiple Currencies:** Add `currency: String` to `ExpenseEntity`, update `DecimalExtensions`
6. **Widgets:** Create WidgetExtension, use App Groups for shared container

## Testing Strategy (Not Implemented)

If you add tests later:

1. **Unit Tests:**
   - `Decimal` conversion (String ↔ Decimal)
   - Month filtering logic
   - Category ordering after move
   - Currency formatting

2. **Integration Tests:**
   - SwiftData CRUD operations
   - Relationship cascade (delete category → expenses)
   - Default data seeding

3. **UI Tests:**
   - Add expense flow
   - Category reordering
   - Month navigation
   - Delete with protection alert

## Dependencies

**Zero external dependencies**. Uses only:
- `import SwiftUI`
- `import SwiftData`
- `import Foundation`

No SPM packages, no CocoaPods, no Carthage.

## Build Settings

- **Deployment Target:** iOS 26.0+
- **Swift Version:** Latest (automatic)
- **Architectures:** arm64 (iPhone only)
- **Code Signing:** Automatic
- **Capabilities:** None required (no CloudKit, no Push, no HealthKit)

## Future Considerations

**If scaling beyond MVP:**
- Add pagination for expense list (if >1000 items)
- Add indexes to SwiftData models (`@Attribute(.indexed)`)
- Use background context for bulk operations
- Add Spotlight search integration
- Add iOS Shortcuts support
- Export to CSV/PDF via `ShareLink`

**Design System:**
All UI uses system colors/fonts for automatic Dark Mode support:
- `.accentColor` (user's preferred tint)
- `.secondary`, `.tertiary` (semantic colors)
- `.systemBackground`, `.secondarySystemGroupedBackground`
- System font weights: `.regular`, `.medium`, `.semibold`, `.bold`

---

**Built with care for iOS 26.** No cruft, no bloat, just clean Swift. 🚀
