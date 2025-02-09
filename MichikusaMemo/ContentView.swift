import SwiftUI

struct ContentView: View {
    @State private var isSettingScreen: Bool = false

    var body: some View {
        ZStack {
            if isSettingScreen {
                MemoScreen()
                    .opacity(1)
                    .allowsHitTesting(false)
                    .animation(.easeInOut, value: isSettingScreen)

                MapScreen()
                    .opacity(0.7)
                    .allowsHitTesting(true)
                    .animation(.easeInOut, value: isSettingScreen)
            } else {
                MapScreen()
                    .opacity(0.7)
                    .allowsHitTesting(false)
                    .animation(.easeInOut, value: isSettingScreen)

                MemoScreen()
                    .opacity(0.7)
                    .allowsHitTesting(true)
                    .animation(.easeInOut, value: isSettingScreen)
            }

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
