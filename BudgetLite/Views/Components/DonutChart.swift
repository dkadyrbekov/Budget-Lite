import SwiftUI

struct DonutChart: View {
    let categoryStats: [(category: CategoryEntity, amount: Decimal, percentage: Double)]

    private let colors: [Color] = [
        .blue, .green, .orange, .purple, .pink, .red, .yellow, .cyan, .mint, .indigo
    ]

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            let radius = size * 0.4
            let lineWidth = size * 0.15

            ZStack {
                // Draw segments
                ForEach(Array(categoryStats.enumerated()), id: \.element.category.id) { index, stat in
                    let color = colors[index % colors.count]
                    DonutSegment(
                        startAngle: startAngle(for: index),
                        endAngle: endAngle(for: index),
                        color: color
                    )
                    .frame(width: size, height: size)
                }

                // Center hole
                Circle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(width: radius * 2 - lineWidth * 2, height: radius * 2 - lineWidth * 2)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private func startAngle(for index: Int) -> Angle {
        let previousPercentages = categoryStats.prefix(index).map(\.percentage).reduce(0, +)
        return Angle(degrees: previousPercentages * 3.6 - 90)
    }

    private func endAngle(for index: Int) -> Angle {
        let percentagesUpToThis = categoryStats.prefix(index + 1).map(\.percentage).reduce(0, +)
        return Angle(degrees: percentagesUpToThis * 3.6 - 90)
    }
}

struct DonutSegment: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            let lineWidth = size * 0.15

            Path { path in
                let center = CGPoint(x: size / 2, y: size / 2)
                let radius = size * 0.4

                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
        }
    }
}
