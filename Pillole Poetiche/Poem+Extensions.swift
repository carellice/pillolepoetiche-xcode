import Foundation
import SwiftUI

// MARK: - Poem Extensions for Widgets
extension Poem {
    
    // ❌ RIMUOVI QUESTA PARTE - placeholder è già in Poem.swift
    // static var placeholder: Poem { ... }
    
    // URL per deep linking
    var widgetURL: URL? {
        return URL(string: "pillolepoetiche://poem/\(id.uuidString)")
    }
    
    // Versione ottimizzata per widget piccoli
    var shortDescription: String {
        let limit = 80
        if poem.count <= limit {
            return poem
        } else {
            let truncated = String(poem.prefix(limit))
            if let lastSpace = truncated.lastIndex(of: " ") {
                return String(truncated[..<lastSpace]) + "..."
            } else {
                return truncated + "..."
            }
        }
    }
    
    // Autore formattato per widget
    var formattedAuthor: String {
        return "— \(author)"
    }
}

// MARK: - PoemsData Extensions for Widgets
extension PoemsData {
    
    // Trova poesia per ID con debug migliorato
    func findPoem(by id: UUID) -> Poem? {
        print("🔍 Debug App: Cercando poesia con ID: \(id.uuidString)")
        print("🔍 Debug App: Ho \(poems.count) poesie disponibili")
        
        // Mostra i primi 3 ID per confronto
        for (index, poem) in poems.prefix(3).enumerated() {
            print("🔍 Debug App: Poesia \(index): ID=\(poem.id.uuidString), Titolo='\(poem.title)'")
        }
        
        if let poem = poems.first(where: { $0.id == id }) {
            print("✅ Debug App: Poesia TROVATA!")
            return poem
        }
        
        print("❌ Debug App: Poesia NON trovata")
        return nil
    }
}
