import Foundation
import SwiftUI

// MARK: - Deep Link Manager
class DeepLinkingManager: ObservableObject {
    @Published var selectedPoemID: UUID?
    @Published var selectedAuthor: String?
    @Published var shouldShowSpecificPoem: Bool = false
    @Published var shouldShowAuthor: Bool = false
    
    func handle(url: URL) {
        guard url.scheme == "pillolepoetiche" else { return }
        
        print("🔗 Deep Link: Ricevuto URL: \(url)")
        
        switch url.host {
        case "open":
            print("🔗 Deep Link: Aprendo app generale")
            openApp()
            
        case "poem":
            if let poemIDString = url.pathComponents.dropFirst().first,
               let poemID = UUID(uuidString: poemIDString) {
                print("🔗 Deep Link: Aprendo poesia con ID: \(poemID)")
                openSpecificPoem(id: poemID)
            } else {
                print("❌ Deep Link: ID poesia non valido")
                openApp()
            }
            
        case "poemIndex":
            if let indexString = url.pathComponents.dropFirst().first,
               let index = Int(indexString) {
                print("🔗 Deep Link: Aprendo poesia all'indice \(index)")
                openPoemByIndex(index: index)
            } else {
                print("❌ Deep Link: Indice non valido")
                openApp()
            }
            
        case "author":
            if let authorName = url.pathComponents.dropFirst().first?.removingPercentEncoding {
                print("🔗 Deep Link: Aprendo autore: \(authorName)")
                openAuthor(name: authorName)
            } else {
                print("❌ Deep Link: Nome autore non valido")
                openApp()
            }
            
        default:
            print("🔗 Deep Link: Host sconosciuto, aprendo app")
            openApp()
        }
    }
    
    private func openApp() {
        selectedPoemID = nil
        selectedAuthor = nil
        shouldShowSpecificPoem = false
        shouldShowAuthor = false
        print("📱 Deep Link: App aperta normalmente")
    }
    
    private func openSpecificPoem(id: UUID) {
        selectedPoemID = id
        shouldShowSpecificPoem = true
        shouldShowAuthor = false
        print("📖 Deep Link: Impostata poesia ID: \(id)")
    }
    
    private func openPoemByIndex(index: Int) {
        let poemsData = PoemsData()
        print("🔗 Deep Link: Ho \(poemsData.poems.count) poesie, cerco indice \(index)")
        
        if index >= 0 && index < poemsData.poems.count {
            let poem = poemsData.poems[index]
            selectedPoemID = poem.id
            shouldShowSpecificPoem = true
            shouldShowAuthor = false
            print("✅ Deep Link: Trovata poesia: '\(poem.title)' di \(poem.author)")
        } else {
            print("❌ Deep Link: Indice \(index) fuori range (0-\(poemsData.poems.count-1))")
            openApp()
        }
    }
    
    private func openAuthor(name: String) {
        selectedAuthor = name
        shouldShowAuthor = true
        shouldShowSpecificPoem = false
        print("👤 Deep Link: Impostato autore: \(name)")
    }
    
    func resetState() {
        selectedPoemID = nil
        selectedAuthor = nil
        shouldShowSpecificPoem = false
        shouldShowAuthor = false
        print("🔄 Deep Link: Stato resettato")
    }
}

// MARK: - URL Schemes
struct URLSchemes {
    static let app = "pillolepoetiche"
    
    struct Hosts {
        static let open = "open"
        static let poem = "poem"
        static let poemIndex = "poemIndex"
        static let author = "author"
    }
    
    static func openApp() -> URL? {
        return URL(string: "\(app)://\(Hosts.open)")
    }
    
    static func openPoem(id: UUID) -> URL? {
        return URL(string: "\(app)://\(Hosts.poem)/\(id.uuidString)")
    }
    
    static func openPoemByIndex(index: Int) -> URL? {
        return URL(string: "\(app)://\(Hosts.poemIndex)/\(index)")
    }
    
    static func openAuthor(name: String) -> URL? {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? name
        return URL(string: "\(app)://\(Hosts.author)/\(encodedName)")
    }
}
