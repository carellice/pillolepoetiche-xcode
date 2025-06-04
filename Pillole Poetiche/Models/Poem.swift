import Foundation

struct Poem: Identifiable, Codable {
    let id = UUID()
    let title: String
    let poem: String
    let author: String
    
    var displayTitle: String {
        return title.isEmpty ? "Poesia" : title
    }
    
    var shareText: String {
        //let link = "https://pillolepoetiche.netlify.app/"
        let link = "https://flavioceccarelli.org"
        if title.isEmpty {
            return "\(poem)\n\n- \(author)\n\n\(link)"
        } else {
            return "\(title)\n\n\(poem)\n\n- \(author)\n\n\(link)"
        }
    }
}

// Estensione per confrontare poesie
extension Poem: Equatable {
    static func == (lhs: Poem, rhs: Poem) -> Bool {
        return lhs.id == rhs.id
    }
}
