import Foundation
import SwiftUI
import Combine

class MonthStore: ObservableObject {
    @Published var selectedDate: Date

    init() {
        self.selectedDate = Date()
    }

    var monthStart: Date {
        Calendar.current.startOfMonth(for: selectedDate)
    }

    var monthEnd: Date {
        Calendar.current.endOfMonth(for: selectedDate)
    }

    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: selectedDate)
    }

    func previousMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) {
            selectedDate = newDate
        }
    }

    func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) {
            selectedDate = newDate
        }
    }

    func isCurrentMonth() -> Bool {
        Calendar.current.isDate(selectedDate, equalTo: Date(), toGranularity: .month)
    }
}
