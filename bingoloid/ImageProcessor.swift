import UIKit
import Vision

class ImageProcessor {
    /// Detect numbers from an image using OCR
    /// This is a placeholder implementation using basic Vision framework
    /// In production, you would use more advanced ML models or third-party services
    func detectNumbers(from image: UIImage) -> [Int] {
        var detectedNumbers: [Int] = []
        
        // Guard against invalid images
        guard let cgImage = image.cgImage else {
            return detectedNumbers
        }
        
        // Create Vision request for text recognition
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        // Process the image
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
            
            // Extract recognized text and find numbers
            if let observations = request.results as? [VNRecognizedTextObservation] {
                for observation in observations {
                    if let topCandidate = observation.topCandidates(1).first {
                        let recognizedText = topCandidate.string
                        
                        // Extract numbers from recognized text
                        let numberStrings = recognizedText.split { !$0.isNumber }
                        for numberStr in numberStrings {
                            if let number = Int(numberStr) {
                                // Filter to valid bingo numbers (1-75)
                                if (1...75).contains(number) && !detectedNumbers.contains(number) {
                                    detectedNumbers.append(number)
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print("Vision recognition error: \(error)")
        }
        
        // Sort detected numbers for consistency
        return detectedNumbers.sorted()
    }
    
    /// Simulate number detection for testing purposes
    /// In production, remove this and use real OCR
    func simulateNumberDetection() -> [Int] {
        // Return some random numbers for testing
        var numbers: [Int] = []
        for _ in 0..<5 {
            numbers.append(Int.random(in: 1...75))
        }
        return numbers.sorted()
    }
}
