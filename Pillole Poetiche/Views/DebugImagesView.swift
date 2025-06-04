import SwiftUI

// Aggiungi questa vista temporanea per testare
struct DebugImagesView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Test Immagini")
                .font(.title)
            
            // Test diretto dell'immagine
            if let image = UIImage(named: "albert_einstein") {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                Text("✅ Immagine trovata!")
                    .foregroundColor(.green)
            } else {
                Circle()
                    .fill(.red)
                    .frame(width: 100, height: 100)
                    .overlay {
                        Text("❌")
                            .font(.largeTitle)
                    }
                Text("❌ Immagine NON trovata")
                    .foregroundColor(.red)
            }
            
            // Test dell'avatar
            AuthorAvatarView(author: "Albert Einstein", size: 100)
            
            // Lista di tutte le immagini nel bundle
            Text("Immagini nel bundle:")
                .font(.headline)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(getAllImageNames(), id: \.self) { imageName in
                        Text("📷 \(imageName)")
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
    }
    
    func getAllImageNames() -> [String] {
        guard let bundlePath = Bundle.main.resourcePath else { return [] }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: bundlePath)
            return files.filter { file in
                let ext = (file as NSString).pathExtension.lowercased()
                return ["png", "jpg", "jpeg", "heic"].contains(ext)
            }
        } catch {
            return ["Errore nel leggere le immagini: \(error.localizedDescription)"]
        }
    }
}

// Aggiungi questo preview temporaneo
#Preview {
    DebugImagesView()
}
