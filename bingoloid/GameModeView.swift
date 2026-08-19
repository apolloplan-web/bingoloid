import SwiftUI

struct GameModeView: View {
    @ObservedObject var gameManager: BingoGameManager
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("BINGO GAME")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    gameManager.toggleMode()
                }) {
                    Text("📸 CHECK MODE")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(20)
            .background(Color.indigo)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Current Number Display - Prominent
                    if let currentNumber = gameManager.currentNumber {
                        VStack(spacing: 12) {
                            Text("NOW ANNOUNCING")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .tracking(1.5)
                            
                            Text("\(currentNumber)")
                                .font(.system(size: 120, weight: .bold, design: .default))
                                .foregroundColor(.red)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            Text("Number Called!")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(Color.orange)
                                .cornerRadius(8)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(16)
                    }
                    
                    // Generate Button
                    Button(action: {
                        gameManager.generateBingoNumber()
                    }) {
                        Text("GENERATE NEXT NUMBER")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .padding(.horizontal, 20)
                    
                    // Previous Numbers
                    VStack(alignment: .leading, spacing: 12) {
                        Text("ANNOUNCED NUMBERS")
                            .font(.headline)
                            .padding(.horizontal, 20)
                        
                        if gameManager.announcedNumbers.isEmpty {
                            Text("No numbers announced yet")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 20)
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(gameManager.announcedNumbers, id: \.self) { number in
                                    HStack {
                                        Text("\(number)")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(width: 50)
                                            .padding(12)
                                            .background(Color.blue)
                                            .cornerRadius(8)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical, 20)
            }
        }
        .background(Color(.systemGray6))
    }
}

#Preview {
    GameModeView(gameManager: BingoGameManager())
        .preferredColorScheme(.light)
}
