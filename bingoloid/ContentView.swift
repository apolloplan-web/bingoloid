import SwiftUI

struct ContentView: View {
    @StateObject private var gameManager = BingoGameManager()
    
    var body: some View {
        ZStack {
            if gameManager.isGameMode {
                GameModeView(gameManager: gameManager)
            } else {
                CheckModeView(gameManager: gameManager)
            }
        }
        .environmentObject(gameManager)
    }
}

#Preview {
    ContentView()
}
