import SwiftUI

struct AuthorImageManager {
    
    // Mappa degli autori con le loro immagini
    private static let authorImages: [String: String] = [
        // Autori classici italiani
        "Luigi Pirandello": "luigi_pirandello",
        "Giacomo Leopardi": "giacomo_leopardi",
        "Cesare Pavese": "cesare_pavese",
        "Eugenio Montale": "eugenio_montale",
        "Pier Paolo Pasolini": "pasolini",
        "Italo Svevo": "italo_svevo",
        "Italo Calvino": "italo_calvino",
        "Ugo Foscolo": "ugo_foscolo",
        "Alessandro Manzoni": "alessandro_manzoni",
        "Giovanni Pascoli": "giovanni_pascoli",
        "Alda Merini": "alda_merini",
        "Salvatore Quasimodo": "salvatore_quasimodo",
        "Gaio Valerio Catullo": "catullo",
        
        // Filosofi e pensatori antichi
        "Platone": "platone",
        "Seneca": "seneca",
        "Marco Aurelio": "marco_aurelio",
        "Socrate": "socrate",
        "Confucio": "confucio",
        "Sofocle": "sofocle",
        "Ovidio": "ovidio",
        
        // Autori internazionali classici
        "William Shakespeare": "william_shakespeare",
        "Charles Dickens": "charles_dickens",
        "Emily Bronte": "emily_bronte",
        "Oscar Wilde": "oscar_wilde",
        "Mark Twain": "mark_twain",
        "John Keats": "john_keats",
        
        // Autori francesi
        "Marcel Proust": "marcel_proust",
        "Antoine de Saint-Exupèry": "saint_exupery",
        "Rousseau": "rousseau",
        
        // Autori tedeschi e austriaci
        "Friedrich Nietzsche": "friedrich_nietzsche",
        "Franz Kafka": "franz_kafka",
        "J. W. Goethe": "goethe",
        "Sigmund Freud": "sigmund_freud",
        
        // Autori russi
        "Fëdor Dostoevskij": "dostoevskij",
        
        // Autori americani
        "Charles Bukowski": "charles_bukowski",
        "Ernest Hemingway": "ernest_hemingway",
        "Maya Angelou": "maya_angelou",
        "Richard Yates": "richard_yates",
        "William James": "william_james",
        "Anthony Robbins": "anthony_robbins",
        "Jimi Hendrix": "jimi_hendrix",
        
        // Scienziati e inventori
        "Albert Einstein": "albert_einstein",
        "Stephen Hawking": "stephen_hawking",
        "Alexander Graham Bell": "alexander_bell",
        
        // Artisti
        "Van Gogh": "van_gogh",
        "Henri Matisse": "henri_matisse",
        
        // Musicisti e poeti contemporanei
        "Leonard Cohen": "leonard_cohen",
        "Pablo Neruda": "pablo_neruda",
        
        // Psicologi e pensatori moderni
        "Carl Jung": "carl_jung",
        "Erich Fromm": "erich_fromm",
        
        // Autori sudamericani
        "Jorge Luis Borges": "borges",
        "José Saramago": "saramago",
        
        // Autori dell'Est Europa
        "Blaga Dimitrova": "blaga_dimitrova",
        "Ghiannis Ritsos": "ghiannis_ritsos",
        
        // Personaggi politici
        "Theodore Roosevelt": "theodore_roosevelt",
        
        // Autori italiani contemporanei
        "Roberto Benigni": "roberto_benigni",
        "Zero Calcare": "zero_calcare",
        "Enrico Galianio": "enrico_galianio",
        "Gianluca Gotto": "gianluca_gotto",
        
        // Autori fantasy moderni
        "Brandon Sanderson": "brandon_sanderson",
        
        // Autori contemporanei e blogger
        "Olivia S.": "olivia_s",
        "Hanna J. Rose": "hanna_j_rose",
        "Sofia J. Ross": "sofia_j_ross",
        "Michele Vitale": "michele_vitale",
        "Francesco Piscitelli": "francesco_piscitelli",
        "Anima Di Venere": "anima_di_venere",
        
        // Personaggi fittizi
        "May Parker": "may_parker",
        "Piccolo Principe": "piccolo_principe"
        
        // Nota: "Anonimo" non ha immagine, mostrerà sempre le iniziali "AN"
    ]
    
    // Funzione per ottenere l'immagine dell'autore o nil se non esiste
    static func getAuthorImage(_ author: String) -> String? {
        return authorImages[author]
    }
    
    // Funzione per verificare se l'autore ha un'immagine disponibile nel bundle
    static func hasImage(for author: String) -> Bool {
        guard let imageName = authorImages[author] else { return false }
        
        // Per Asset Catalog, basta controllare se UIImage riesce a caricare l'immagine
        return UIImage(named: imageName) != nil
    }
    
    // Funzione per ottenere le iniziali dell'autore
    static func getAuthorInitials(_ author: String) -> String {
        let words = author.split(separator: " ")
        if words.count >= 2 {
            return String(words[0].prefix(1) + words[1].prefix(1)).uppercased()
        } else {
            return String(author.prefix(2)).uppercased()
        }
    }
}

// Vista componente per l'avatar dell'autore - Versione semplificata
struct AuthorAvatarView: View {
    let author: String
    let size: CGFloat
    
    init(author: String, size: CGFloat = 40) {
        self.author = author
        self.size = size
    }
    
    var body: some View {
        // Versione semplificata per debug
        ZStack {
            // Background sempre visibile per debug
            Circle()
                .fill(.blue.gradient)
                .frame(width: size, height: size)
            
            // Controllo se c'è l'immagine
            if let imageName = AuthorImageManager.getAuthorImage(author),
               let uiImage = UIImage(named: imageName) {
                // Mostra l'immagine
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(Circle())
            } else {
                // Mostra sempre le iniziali
                Text(AuthorImageManager.getAuthorInitials(author))
                    .font(.system(size: size * 0.35, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
