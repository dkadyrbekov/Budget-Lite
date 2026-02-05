import Foundation

extension Calendar {
    func startOfMonth(for date: Date) -> Date {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components) ?? date
    }

    func endOfMonth(for date: Date) -> Date {
        guard let startOfNextMonth = self.date(byAdding: DateComponents(month: 1), to: startOfMonth(for: date)),
              let endOfMonth = self.date(byAdding: DateComponents(day: -1), to: startOfNextMonth) else {
            return date
        }
        return endOfMonth
    }
}
