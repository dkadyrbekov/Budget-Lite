import SwiftUI

struct MonthNavigator: View {
    @EnvironmentObject private var monthStore: MonthStore

    var body: some View {
        HStack {
            Button {
                monthStore.previousMonth()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundStyle(.primary)
            }

            Spacer()

            Text(monthStore.monthYearString)
                .font(.headline)

            Spacer()

            Button {
                monthStore.nextMonth()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundStyle(.primary)
            }
            .disabled(monthStore.isCurrentMonth())
        }
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }
}
