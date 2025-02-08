import SwiftUI

struct ContentView: View {
    @State private var isSettingScreen: Bool = false

    var body: some View {
        ZStack {
            MemoScreen()
                .opacity(isSettingScreen ? 1 : 0.7)
                .animation(.easeInOut, value: isSettingScreen)

            MapScreen()
                .opacity(isSettingScreen ? 0.7 : 0.7)
                .animation(.easeInOut, value: isSettingScreen)

            VStack {
                HStack {
                    Spacer()
                    CustomToggle(isOn: $isSettingScreen)
                        .frame(width: 120, height: 50)
                        .padding()
                }
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
