# Budget Lite - Setup Instructions

## Project Overview

Budget Lite is a fully offline, iPhone-only personal expense tracker built with SwiftUI and SwiftData. It features:
- ✅ Fast expense entry (optimized for one-handed use)
- ✅ Category management with drag-to-reorder
- ✅ Monthly statistics with pure SwiftUI donut chart
- ✅ Complete offline functionality (no servers, accounts, or sync)
- ✅ iOS 26.0+ target

## How to Create and Run the Project

### Step 1: Create New Xcode Project

1. Open Xcode (latest version supporting iOS 26)
2. Select **File > New > Project**
3. Choose **iOS** tab, then select **App** template
4. Click **Next**
5. Configure the project:
   - **Product Name:** `BudgetLite`
   - **Team:** Select your team (or leave as-is for now)
   - **Organization Identifier:** `com.yourname` (or your preferred bundle ID)
   - **Interface:** **SwiftUI**
   - **Language:** **Swift**
   - **Storage:** **None** (we'll use SwiftData manually)
   - **Include Tests:** Uncheck both boxes (optional)
6. Click **Next** and choose a location to save
7. Click **Create**

### Step 2: Configure Project Settings

1. In Xcode, select the **BudgetLite** project in the navigator
2. Select the **BudgetLite** target
3. Under **General** tab:
   - **Minimum Deployments:** Set to **iOS 26.0**
   - **Supported Destinations:** Uncheck **iPad** (iPhone only)
4. Under **Signing & Capabilities:**
   - Select your **Team** from the dropdown
   - Xcode will automatically manage signing

### Step 3: Delete Default Files

1. In the Project Navigator, **delete** these auto-generated files:
   - `ContentView.swift` (we'll replace it)
   - `BudgetLiteApp.swift` (we'll replace it)
   - Move them to Trash when prompted

### Step 4: Add Project Files

1. **Drag the entire `BudgetLite/` folder** from the repository into Xcode:
   - Right-click on the **BudgetLite** group in the Project Navigator
   - Select **Add Files to "BudgetLite"...**
   - Navigate to the cloned repository
   - Select the **BudgetLite** folder
   - ✅ Check **Copy items if needed**
   - ✅ Check **Create groups**
   - ✅ Ensure **BudgetLite** target is checked
   - Click **Add**

2. Your Project Navigator should now show:
   ```
   BudgetLite
   ├── BudgetLiteApp.swift
   ├── Models/
   │   ├── CategoryEntity.swift
   │   └── ExpenseEntity.swift
   ├── Stores/
   │   └── MonthStore.swift
   ├── Views/
   │   ├── Tabs/
   │   ├── Sheets/
   │   └── Components/
   ├── Helpers/
   └── Assets.xcassets
   ```

### Step 5: Build and Run

1. Select a simulator or connected iPhone:
   - Click the device selector next to the Run button
   - Choose **iPhone 16 Pro** (or any iPhone simulator)
   - Or connect a physical iPhone running iOS 26+

2. **Build the project:**
   - Press **⌘ + B** or select **Product > Build**
   - Verify there are no compilation errors

3. **Run the app:**
   - Press **⌘ + R** or click the **Play** button
   - The app should launch on the simulator/device

### Step 6: First Launch

When the app launches for the first time:
- Four default categories will be created: Food 🍔, Transport 🚗, Home 🏠, Fun 🎮
- You'll see an empty Expenses list with "No expenses this month"
- Tap the **+** button to add your first expense

## Running on a Physical iPhone

1. Connect your iPhone via USB
2. Trust the computer if prompted
3. In Xcode, select your iPhone from the device selector
4. **First time only:** You may need to:
   - Go to iPhone **Settings > General > VPN & Device Management**
   - Trust your developer certificate
5. Press **⌘ + R** to run

## Project Architecture

- **SwiftData Models:** CategoryEntity and ExpenseEntity with proper relationships
- **MVVM Pattern:** ViewModels use SwiftData queries directly
- **MonthStore:** Shared state for month selection across tabs
- **Pure SwiftUI:** No UIKit, no third-party dependencies
- **Decimal Precision:** Amounts stored as String, exposed as Decimal (no floating-point errors)

## Key Features Implemented

### ⚡ Fast Expense Entry
- Auto-focus on amount field
- Numeric keyboard
- Large tappable category tiles
- Minimal required fields (amount + category)
- Haptic feedback on save
- Default date to today

### 📊 Statistics
- Pure SwiftUI donut chart (no libraries)
- Monthly total
- Category breakdown with percentages
- Deterministic color palette

### 🗂️ Category Management
- Drag-to-reorder with persistent sortOrder
- Emoji picker (common emojis + custom paste)
- Delete protection (blocks if expenses exist)

### 📅 Month Navigation
- Shared month state across Expenses + Stats tabs
- Previous/Next navigation
- Disable "next" when viewing current month

## Troubleshooting

**Build Errors:**
- Ensure iOS Deployment Target is set to 26.0 or higher
- Clean build folder: **Product > Clean Build Folder** (⇧⌘K)
- Restart Xcode if needed

**Simulator Issues:**
- Choose a newer iPhone simulator (iPhone 15/16)
- Reset simulator: **Device > Erase All Content and Settings**

**Signing Issues:**
- Go to **Signing & Capabilities** and select your Team
- For free accounts, change the Bundle ID to something unique

## Customization

All code is fully editable and well-organized:
- **Colors:** Modify the `colors` array in `DonutChart.swift`
- **Default Categories:** Edit `DataSeeder.swift`
- **Currency:** Change `currencyCode` in `DecimalExtensions.swift`
- **Emoji List:** Edit `commonEmojis` in `EmojiPicker.swift`

## No External Dependencies

This project uses **zero third-party libraries**. Everything is built with:
- SwiftUI (UI framework)
- SwiftData (persistence)
- Foundation (data types, formatting)

Enjoy tracking your expenses! 🎉
