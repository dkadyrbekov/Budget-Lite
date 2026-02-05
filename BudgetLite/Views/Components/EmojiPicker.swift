import SwiftUI

struct EmojiPicker: View {
    @Binding var selectedEmoji: String

    private let commonEmojis = [
        "💸", "💰", "💵", "💳", "🏦",
        "🍔", "🍕", "🍜", "🍱", "☕️",
        "🚗", "🚕", "🚙", "🚌", "✈️",
        "🏠", "🏡", "🔑", "🛋️", "🔧",
        "🎮", "🎬", "🎵", "🎨", "📚",
        "👕", "👔", "👗", "👟", "👜",
        "🏥", "💊", "🩺", "💉", "🏋️",
        "🎓", "📝", "✏️", "📖", "🖥️",
        "🛒", "🛍️", "📱", "💻", "⌚️",
        "🎁", "🎉", "🎂", "💐", "❤️"
    ]

    @State private var customEmoji = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: [
                GridItem(.adaptive(minimum: 44), spacing: 8)
            ], spacing: 8) {
                ForEach(commonEmojis, id: \.self) { emoji in
                    Button {
                        selectedEmoji = emoji
                    } label: {
                        Text(emoji)
                            .font(.system(size: 32))
                            .frame(width: 44, height: 44)
                            .background(
                                selectedEmoji == emoji ? Color.accentColor.opacity(0.2) : Color.clear
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }

            Divider()

            HStack {
                Text("Or paste emoji:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                TextField("🎯", text: $customEmoji)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: customEmoji) { oldValue, newValue in
                        if !newValue.isEmpty {
                            selectedEmoji = String(newValue.prefix(2))
                            customEmoji = ""
                        }
                    }
            }
        }
    }
}
