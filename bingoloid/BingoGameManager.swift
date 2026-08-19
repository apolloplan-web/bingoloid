import Foundation
import SwiftUI

class BingoGameManager: ObservableObject {
    @Published var isGameMode = true
    @Published var currentNumber: Int?
    @Published var announcedNumbers: [Int] = []
    
    private let numberRange = 1...75
    private var usedNumbers: Set<Int> = []
    
    init() {
        // Initialize with empty state
    }
    
    /// Generate a random bingo number that hasn't been used yet
    func generateBingoNumber() {
        // Get available numbers
        let availableNumbers = numberRange.filter { !usedNumbers.contains($0) }
        
        guard !availableNumbers.isEmpty else {
            // All numbers have been used, reset
            usedNumbers.removeAll()
            currentNumber = nil
            announcedNumbers.removeAll()
            return
        }
        
        // Pick random number
        if let randomNumber = availableNumbers.randomElement() {
            currentNumber = randomNumber
            usedNumbers.insert(randomNumber)
            
            // Add to announced numbers at the beginning of array (most recent first)
            announcedNumbers.insert(randomNumber, at: 0)
        }
    }
    
    /// Toggle between GAME MODE and CHECK MODE
    func toggleMode() {
        isGameMode.toggle()
    }
    
    /// Reset the game
    func resetGame() {
        currentNumber = nil
        announcedNumbers.removeAll()
        usedNumbers.removeAll()
    }
}
