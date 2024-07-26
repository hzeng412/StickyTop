import SwiftUI

struct StickyView: View {
    @Binding var sticky: Sticky
    var onDelete: () -> Void
    
    let pinkColor = Color(hex: "FF7EB9")
    let blueColor = Color(hex: "7AFCFF")
    let yellowColor = Color.yellow
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(formatDate(sticky.date))
                    .font(.caption)
                    .foregroundColor(.black)
                
                Spacer()
                
                // Pink color button
                ColorButton(color: pinkColor) {
                    sticky.color = pinkColor
                }
                
                // Light blue color button
                ColorButton(color: blueColor) {
                    sticky.color = blueColor
                }
                
                // Yellow color button
                ColorButton(color: yellowColor) {
                    sticky.color = yellowColor
                }
                
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                }
            }
            .font(.caption)
            .foregroundColor(.black)
            
            TextField("", text: $sticky.text, axis: .vertical)
                .lineLimit(5...10)
                .font(.body)
                .foregroundColor(.black)
                .textFieldStyle(PlainTextFieldStyle())
                .background(Color.clear)
        }
        .padding(8)
        .background(sticky.color)
        .cornerRadius(8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

struct ColorButton: View {
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(Color.white)
                .frame(width: 18, height: 18)
                .overlay(
                    Circle()
                        .fill(color)
                        .frame(width: 14, height: 14)
                )
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 0.5)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}



// Extension to create Color from hex string
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
