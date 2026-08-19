import SwiftUI
import PhotosUI

struct CheckModeView: View {
    @ObservedObject var gameManager: BingoGameManager
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var imageProcessor = ImageProcessor()
    @State private var detectedNumbers: [Int] = []
    @State private var matchResult: String?
    @State private var showResult = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    gameManager.toggleMode()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("GAME MODE")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                }
                
                Spacer()
                
                Text("CHECK MODE")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(20)
            .background(Color.indigo)
            
            Divider()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📋 Instructions")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Label("準備: ビンゴシートを用意してください", systemImage: "checkmark.circle")
                            Label("撮影: 穴があいたシートを撮影", systemImage: "camera")
                            Label("確認: 番号を照合します", systemImage: "magnifyingglass")
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                    
                    // Image Picker Button
                    Button(action: {
                        showImagePicker = true
                    }) {
                        VStack(spacing: 12) {
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                            
                            Text("📸 写真でチェック")
                                .font(.headline)
                                .foregroundColor(.blue)
                            
                            Text("ビンゴシートの写真を選択")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(40)
                        .background(Color.blue.opacity(0.05))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue, lineWidth: 2))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    // Selected Image Display
                    if let selectedImage = selectedImage {
                        VStack(spacing: 12) {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 300)
                                .cornerRadius(8)
                            
                            Button(action: {
                                processImage()
                            }) {
                                HStack {
                                    Image(systemName: "magnifyingglass.circle.fill")
                                    Text("ANALYZE & MATCH")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color.green)
                                .cornerRadius(8)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    }
                    
                    // Result Display
                    if showResult, let matchResult = matchResult {
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: matchResult == "MATCHED" ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(matchResult == "MATCHED" ? .green : .red)
                                
                                Text(matchResult)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(matchResult == "MATCHED" ? .green : .red)
                            }
                            
                            if !detectedNumbers.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Detected Numbers:")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    
                                    let matched = detectedNumbers.filter { gameManager.announcedNumbers.contains($0) }
                                    let unmatched = detectedNumbers.filter { !gameManager.announcedNumbers.contains($0) }
                                    
                                    if !matched.isEmpty {
                                        HStack {
                                            Text("✓ Matched:")
                                                .foregroundColor(.green)
                                            Text(matched.map(String.init).joined(separator: ", "))
                                                .font(.system(.caption, design: .monospaced))
                                        }
                                    }
                                    
                                    if !unmatched.isEmpty {
                                        HStack {
                                            Text("✗ Unmatched:")
                                                .foregroundColor(.red)
                                            Text(unmatched.map(String.init).joined(separator: ", "))
                                                .font(.system(.caption, design: .monospaced))
                                        }
                                    }
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                            
                            HStack(spacing: 12) {
                                Button(action: {
                                    showResult = false
                                    matchResult = nil
                                    selectedImage = nil
                                    detectedNumbers = []
                                }) {
                                    Text("↩ BACK TO CHECK")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(12)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    gameManager.toggleMode()
                                }) {
                                    Text("GAME MODE 🎮")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(12)
                                        .background(Color.orange)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical, 20)
            }
        }
        .background(Color(.systemGray6))
        .sheet(isPresented: $showImagePicker) {
            ImagePickerView(selectedImage: $selectedImage)
        }
    }
    
    private func processImage() {
        guard let image = selectedImage else { return }
        
        // Simulate OCR number detection from image
        // In production, use Vision framework or ML Kit
        detectedNumbers = imageProcessor.detectNumbers(from: image)
        
        // Check if detected numbers match announced numbers
        let matchedCount = detectedNumbers.filter { gameManager.announcedNumbers.contains($0) }.count
        let totalDetected = detectedNumbers.count
        
        // Determine if match is successful (80% or more detected numbers are from announced numbers)
        if totalDetected > 0 && Double(matchedCount) / Double(totalDetected) >= 0.8 {
            matchResult = "MATCHED"
        } else {
            matchResult = "UNMATCHED"
        }
        
        showResult = true
    }
}

// Image Picker View
struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage, dismiss: dismiss)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var selectedImage: UIImage?
        let dismiss: DismissAction
        
        init(selectedImage: Binding<UIImage?>, dismiss: DismissAction) {
            self._selectedImage = selectedImage
            self.dismiss = dismiss
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                selectedImage = image
            }
            dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss()
        }
    }
}

#Preview {
    CheckModeView(gameManager: BingoGameManager())
        .preferredColorScheme(.light)
}
