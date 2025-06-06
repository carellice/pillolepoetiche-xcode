import SwiftUI
import UIKit

// MARK: - Vista di anteprima per l'immagine generata
struct ImagePreviewView: View {
    let image: UIImage
    let poem: Poem
    @Environment(\.dismiss) var dismiss
    @State private var showingShareSheet = false
    @State private var showingSaveAlert = false
    @State private var saveAlertMessage = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Anteprima dell'immagine
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .background(Color.black.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    
                    // Info sulla poesia
                    VStack(spacing: 8) {
                        if !poem.title.isEmpty {
                            Text(poem.title)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                        }
                        
                        Text("di \(poem.author)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .italic()
                    }
                    .padding(.horizontal)
                    
                    // Pulsanti di azione
                    VStack(spacing: 12) {
                        // Pulsante Condividi
                        Button(action: {
                            showingShareSheet = true
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                                
                                Text("Condividi Immagine")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.blue.gradient, in: RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .blue.opacity(0.3), radius: 4, y: 2)
                        }
                        .buttonStyle(.plain)
                        
                        // Pulsante Salva
                        Button(action: {
                            saveImageToPhotos()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "square.and.arrow.down")
                                    .font(.title3)
                                
                                Text("Salva nelle Foto")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.quaternary, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    Spacer(minLength: 40)
                }
                .padding(20)
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(UIColor.systemBackground),
                        Color(UIColor.secondarySystemBackground)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationTitle("Anteprima Condivisione")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annulla") {
                        dismiss()
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: [image])
            }
            .alert("Salvataggio Foto", isPresented: $showingSaveAlert) {
                Button("OK") { }
            } message: {
                Text(saveAlertMessage)
            }
        }
    }
    
    private func saveImageToPhotos() {
        // Classe helper per gestire il callback del salvataggio
        class ImageSaver: NSObject {
            var completion: ((Bool, String) -> Void)?
            
            @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
                if let error = error {
                    completion?(false, "Errore nel salvataggio: \(error.localizedDescription)")
                } else {
                    completion?(true, "Immagine salvata con successo nelle tue foto!")
                }
            }
        }
        
        let imageSaver = ImageSaver()
        imageSaver.completion = { [weak imageSaver] success, message in
            DispatchQueue.main.async {
                saveAlertMessage = message
                showingSaveAlert = true
                
                if success {
                    // Feedback aptico di successo
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    
                    // Chiudi la vista dopo 2 secondi se il salvataggio è riuscito
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        dismiss()
                    }
                }
            }
            
            // Mantieni il riferimento finché il callback non è completato
            withExtendedLifetime(imageSaver) { }
        }
        
        // Salva l'immagine usando il metodo sicuro
        UIImageWriteToSavedPhotosAlbum(
            image,
            imageSaver,
            #selector(ImageSaver.image(_:didFinishSavingWithError:contextInfo:)),
            nil
        )
    }
}

// MARK: - Share Sheet nativo iOS
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Helper per la condivisione centralizzata
class ShareHelper {
    
    // Funzione per mostrare l'anteprima e poi condividere
    static func showPreviewAndShare(_ poem: Poem, completion: @escaping (Bool) -> Void) {
        Task {
            if let image = await PoemImageGenerator.generateShareableImageAsync(for: poem) {
                await MainActor.run {
                    // Trova la finestra attiva
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first else {
                        completion(false)
                        return
                    }
                    
                    // Trova il view controller attivo
                    var rootViewController = window.rootViewController
                    while let presentedViewController = rootViewController?.presentedViewController {
                        rootViewController = presentedViewController
                    }
                    
                    guard let viewController = rootViewController else {
                        completion(false)
                        return
                    }
                    
                    // Crea e presenta la vista di anteprima
                    let previewView = ImagePreviewView(image: image, poem: poem)
                    let hostingController = UIHostingController(rootView: previewView)
                    
                    // Feedback aptico
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    
                    viewController.present(hostingController, animated: true)
                    completion(true)
                }
            } else {
                await MainActor.run {
                    print("❌ Errore nella generazione dell'immagine")
                    completion(false)
                }
            }
        }
    }
    
    // Funzione legacy per retrocompatibilità (condivisione diretta)
    static func shareImage(_ image: UIImage, from sourceView: UIView? = nil) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("❌ Non riesco a trovare la finestra principale")
            return
        }
        
        var rootViewController = window.rootViewController
        while let presentedViewController = rootViewController?.presentedViewController {
            rootViewController = presentedViewController
        }
        
        guard let viewController = rootViewController else {
            print("❌ Non riesco a trovare il view controller")
            return
        }
        
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        if let popover = activityVC.popoverPresentationController {
            if let sourceView = sourceView {
                popover.sourceView = sourceView
                popover.sourceRect = sourceView.bounds
            } else {
                popover.sourceView = window
                popover.sourceRect = CGRect(x: window.bounds.midX, y: window.bounds.midY, width: 0, height: 0)
            }
            popover.permittedArrowDirections = []
        }
        
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        viewController.present(activityVC, animated: true)
    }
    
    // Nuova funzione per condividere una poesia con anteprima
    static func sharePoem(_ poem: Poem, completion: @escaping (Bool) -> Void) {
        showPreviewAndShare(poem, completion: completion)
    }
}
