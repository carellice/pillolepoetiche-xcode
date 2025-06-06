import SwiftUI
import UIKit

// MARK: - Helper per la condivisione centralizzata
class ShareHelper {
    
    // Funzione centralizzata per condividere un'immagine
    static func shareImage(_ image: UIImage, from sourceView: UIView? = nil) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("❌ Non riesco a trovare la finestra principale")
            return
        }
        
        // Trova il view controller attivo
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
        
        // Configurazione per iPad
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
        
        // Feedback aptico
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        viewController.present(activityVC, animated: true)
    }
    
    // Funzione per condividere una poesia (genera l'immagine e la condivide)
    static func sharePoem(_ poem: Poem, completion: @escaping (Bool) -> Void) {
        Task {
            if let image = await PoemImageGenerator.generateShareableImageAsync(for: poem) {
                await MainActor.run {
                    ShareHelper.shareImage(image)
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
}
