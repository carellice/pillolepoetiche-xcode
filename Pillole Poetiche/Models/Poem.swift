import Foundation

struct Poem: Identifiable, Codable {
    let id: UUID
    let title: String
    let poem: String
    let author: String
    
    init(title: String, poem: String, author: String) {
        self.title = title
        self.poem = poem
        self.author = author
        // Genera ID deterministico basato sul contenuto
        self.id = Self.generateConsistentID(title: title, poem: poem, author: author)
    }
    
    // Computed property per condivisione con il tuo sito
    var shareText: String {
        //let link = "https://www.flavioceccarelli.org";
        let link = "https://apps.apple.com/it/app/pillole-poetiche/id6746839400";
        if title.isEmpty {
            return "\"\(poem)\"\n— \(author)\n\n\(link)"
        } else {
            return "\"\(title)\"\n\(poem)\n— \(author)\n\n\(link)"
        }
    }
    
    // Genera ID consistente basato sul contenuto
    static func generateConsistentID(title: String, poem: String, author: String) -> UUID {
        let combined = "\(title)|\(poem)|\(author)"
        let data = combined.data(using: .utf8) ?? Data()
        
        // Usa SHA256 per creare un hash consistente
        var hasher = Hasher()
        hasher.combine(data)
        let hashValue = hasher.finalize()
        
        // Converte l'hash in UUID deterministico
        let bytes = withUnsafeBytes(of: hashValue) { Array($0) }
        let paddedBytes = bytes + Array(repeating: UInt8(0), count: max(0, 16 - bytes.count))
        let truncatedBytes = Array(paddedBytes.prefix(16))
        
        let uuid = NSUUID(uuidBytes: truncatedBytes).uuidString
        return UUID(uuidString: uuid) ?? UUID()
    }
    
    // ❌ NON AGGIUNGERE placeholder qui se esiste già altrove
}
