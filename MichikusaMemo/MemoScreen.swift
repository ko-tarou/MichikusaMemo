import SwiftUI

struct MemoScreen: View {
    var body: some View {
        ZStack {
            Color(red: 183/255, green: 204/255, blue: 184/255)
                .opacity(0.7)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("SettingScreen")
                    .font(.largeTitle)
                    .padding()
            }
        }
        .navigationTitle("画面1")
    }
}

#Preview {
    MemoScreen()
}
