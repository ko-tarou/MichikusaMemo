import SwiftUI

struct CustomToggle: View {
    @Binding var isOn: Bool

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0))
                .shadow(radius: 2)

            RoundedRectangle(cornerRadius: 25)
                .stroke(Color(hex: "#506352"), lineWidth: 2)

            HStack {
                Circle()
                    .fill(Color(hex: "#506352"))
                    .shadow(radius: 2)
                    .frame(width: 40, height: 40)
                    .offset(x: isOn ? 30 : -30)
                    .animation(.easeInOut, value: isOn)
            }

            HStack {
                Image(systemName: "map")
                    .foregroundColor(Color(hex: "EEF2EA"))
                    .font(.system(size: 24))
                    .opacity(isOn ? 0.5 : 1)
                Spacer()
                Image(systemName: "doc.text")
                    .foregroundColor(Color(hex: "EEF2EA"))
                    .font(.system(size: 24))
                    .opacity(isOn ? 1 : 0.5)
            }
            .padding(.horizontal, 15)
        }
        .frame(height: 50)
        .onTapGesture {
            isOn.toggle()
        }
    }
}

#Preview {
    CustomToggle(isOn: .constant(false))
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.hasPrefix("#") ? hex.index(after: hex.startIndex) : hex.startIndex

        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
