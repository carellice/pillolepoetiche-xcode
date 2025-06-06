import SwiftUI
import UIKit

// MARK: - Vista di anteprima per l'immagine generata (FIX: Spazio bianco rimosso)
struct ImagePreviewView: View {
    let image: UIImage
    let poem: Poem
    @Environment(\.dismiss) var dismiss
    @State private var showingShareSheet = false
    @State private var showingSaveAlert = false
    @State private var saveAlertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // FIX: Area scrollabile con calcolo preciso dell'altezza
                ScrollView {
                    VStack(spacing: responsiveSpacing) {
                        // Anteprima dell'immagine
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: maxImageWidth)
                            .background(Color.black.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: responsiveCornerRadius))
                            .shadow(color: .black.opacity(0.2), radius: responsiveShadowRadius, x: 0, y: responsiveShadowY)
                        
                        // Info sulla poesia
                        VStack(spacing: responsiveInfoSpacing) {
                            if !poem.title.isEmpty {
                                Text(poem.title)
                                    .font(responsiveTitleFont)
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Text("di \(poem.author)")
                                .font(responsiveAuthorFont)
                                .foregroundStyle(.secondary)
                                .italic()
                        }
                        .padding(.horizontal, responsiveHorizontalPadding)
                    }
                    .padding(.top, responsiveContentPadding)
                    .padding(.horizontal, responsiveContentPadding)
                    .padding(.bottom, 16) // FIX: Padding bottom fisso e piccolo
                }
                
                // FIX: Pulsanti in area fissa senza spazio extra
                VStack(spacing: responsiveButtonSpacing) {
                    // Pulsante Condividi
                    Button(action: {
                        showingShareSheet = true
                    }) {
                        HStack(spacing: responsiveButtonIconSpacing) {
                            Image(systemName: "square.and.arrow.up")
                                .font(responsiveButtonIconFont)
                            
                            Text("Condividi Immagine")
                                .font(responsiveButtonFont)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, responsiveButtonPadding)
                        .background(.blue.gradient, in: RoundedRectangle(cornerRadius: responsiveButtonCornerRadius))
                        .shadow(color: .blue.opacity(0.3), radius: responsiveButtonShadow, y: 2)
                    }
                    .buttonStyle(.plain)
                    
                    // Pulsante Salva
                    Button(action: {
                        saveImageToPhotos()
                    }) {
                        HStack(spacing: responsiveButtonIconSpacing) {
                            Image(systemName: "square.and.arrow.down")
                                .font(responsiveButtonIconFont)
                            
                            Text("Salva nelle Foto")
                                .font(responsiveButtonFont)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, responsiveButtonPadding)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: responsiveButtonCornerRadius))
                        .overlay(
                            RoundedRectangle(cornerRadius: responsiveButtonCornerRadius)
                                .stroke(.quaternary, lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, responsiveHorizontalPadding)
                .padding(.top, responsiveButtonAreaTopPadding) // FIX: Solo padding top
                .padding(.bottom, responsiveButtonAreaBottomPadding) // FIX: Padding bottom minimo
                .background(.regularMaterial)
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
            .navigationBarTitleDisplayMode(UIDevice.current.userInterfaceIdiom == .pad ? .large : .inline)
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
    
    // MARK: - Responsive Design Properties per iPad (FIX: Spacing ottimizzati)
    
    private var responsiveSpacing: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 32 : 20
    }
    
    private var responsiveInfoSpacing: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 12 : 8
    }
    
    private var responsiveContentPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 32 : 20
    }
    
    private var responsiveHorizontalPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 40 : 20
    }
    
    // FIX: Padding area pulsanti ottimizzati
    private var responsiveButtonAreaTopPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
    }
    
    private var responsiveButtonAreaBottomPadding: CGFloat {
        // FIX: Padding bottom minimo per evitare spazio bianco
        UIDevice.current.userInterfaceIdiom == .pad ? 24 : 20
    }
    
    private var responsiveButtonSpacing: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12
    }
    
    private var responsiveButtonIconSpacing: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12
    }
    
    private var responsiveButtonPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
    }
    
    private var responsiveCornerRadius: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12
    }
    
    private var responsiveButtonCornerRadius: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12
    }
    
    private var responsiveShadowRadius: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 12 : 8
    }
    
    private var responsiveShadowY: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 6 : 4
    }
    
    private var responsiveButtonShadow: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 6 : 4
    }
    
    // MARK: - Responsive Fonts
    
    private var responsiveTitleFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .title : .headline
    }
    
    private var responsiveAuthorFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .subheadline
    }
    
    private var responsiveButtonFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .headline
    }
    
    private var responsiveButtonIconFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .title3
    }
    
    // MARK: - Layout Calculations (FIX: Calcoli semplificati)
    
    private var maxImageWidth: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 600 // FIX: Larghezza fissa per iPad
        } else {
            return UIScreen.main.bounds.width * 0.9 // FIX: Percentuale per iPhone
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
                    
                    // FIX: Modalità presentazione ottimizzata per iPad
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        hostingController.modalPresentationStyle = .formSheet
                        hostingController.preferredContentSize = CGSize(width: 700, height: 850) // FIX: Altezza leggermente aumentata
                    } else {
                        hostingController.modalPresentationStyle = .automatic
                    }
                    
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

#Preview("Anteprima iPad - Fix Spacing") {
    ImagePreviewView(
        image: UIImage(systemName: "photo")!,
        poem: Poem(
            title: "Test Preview iPad Senza Spazio Bianco",
            poem: "Questa è una poesia di test per vedere l'anteprima ottimizzata per iPad senza spazio bianco sotto i pulsanti.",
            author: "Test Autore"
        )
    )
    .previewDevice("iPad Pro (12.9-inch) (6th generation)")
}

#Preview("Anteprima iPhone - Fix Spacing") {
    ImagePreviewView(
        image: UIImage(systemName: "photo")!,
        poem: Poem(
            title: "Test Preview iPhone",
            poem: "Test per iPhone senza spazio extra.",
            author: "Test Autore"
        )
    )
    .previewDevice("iPhone 15 Pro")
}
