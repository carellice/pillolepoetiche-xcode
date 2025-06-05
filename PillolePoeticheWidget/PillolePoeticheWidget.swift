import WidgetKit
import SwiftUI

struct PoemEntry: TimelineEntry {
    let date: Date
    let poem: Poem
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PoemEntry {
        PoemEntry(date: Date(), poem: Poem.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (PoemEntry) -> ()) {
        let entry = PoemEntry(date: Date(), poem: getRandomPoem())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [PoemEntry] = []
        let currentDate = Date()
        
        // Genera 6 entries per le prossime 24 ore (ogni 4 ore)
        for hourOffset in stride(from: 0, to: 24, by: 4) {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = PoemEntry(date: entryDate, poem: getRandomPoem())
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func getRandomPoem() -> Poem {
        let poemsData = PoemsData()
        let poem = poemsData.getRandomPoem() ?? Poem.placeholder
        
        // Debug: logga l'indice che stiamo usando
        if let index = poemsData.poems.firstIndex(where: { $0.id == poem.id }) {
            print("🔍 Widget: Usando poesia all'indice: \(index)")
            print("🔍 Widget: Titolo: '\(poem.title)'")
            print("🔍 Widget: Autore: \(poem.author)")
        }
        
        return poem
    }
}

// MARK: - Helper Functions
private func createWidgetURL(for poem: Poem) -> URL? {
    let poemsData = PoemsData()
    if let index = poemsData.poems.firstIndex(where: { $0.id == poem.id }) {
        print("🔗 Widget URL: Creando link per indice \(index)")
        return URL(string: "pillolepoetiche://poemIndex/\(index)")
    }
    print("❌ Widget URL: Non trovato indice per poesia")
    return URL(string: "pillolepoetiche://open")
}

struct PillolePoeticheWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                MediumPoemWidget(poem: entry.poem)
            case .systemLarge:
                LargePoemWidget(poem: entry.poem)
            case .systemExtraLarge:
                ExtraLargePoemWidget(poem: entry.poem)
            default:
                MediumPoemWidget(poem: entry.poem)
            }
        }
        .widgetURL(createWidgetURL(for: entry.poem))
    }
}

// MARK: - Medium Widget (4x2)
struct MediumPoemWidget: View {
    let poem: Poem
    @Environment(\.colorScheme) var colorScheme
    
    private var truncatedText: String {
        let limit = 400 // Aumentato da 300 a 400
        if poem.poem.count <= limit {
            return poem.poem
        } else {
            let truncated = String(poem.poem.prefix(limit))
            if let lastSpace = truncated.lastIndex(of: " ") {
                return String(truncated[..<lastSpace]) + "..."
            }
            return truncated + "..."
        }
    }
    
    var body: some View {
        ZStack {
            // Solo background glass, NESSUNA cornice
            RoundedRectangle(cornerRadius: 20)
                .fill(glassBackground)
                .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
            
            VStack(spacing: 6) { // Spacing ridotto ulteriormente
                // SOLO poesia e autore - niente altro
                Text(truncatedText)
                    .font(.callout)
                    .foregroundStyle(primaryTextColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .lineLimit(9) // Aumentato da 8 a 9 righe
                
                Spacer()
                
                // Autore minimalista
                Text("— \(poem.author)")
                    .font(.caption)
                    .foregroundStyle(secondaryTextColor)
                    .italic()
                    .fontWeight(.medium)
            }
            .padding(12) // Padding ulteriormente ridotto da 14 a 12
        }
    }
    
    // MARK: - Glass Effect Colors
    private var glassBackground: Material {
        colorScheme == .dark
            ? .ultraThinMaterial
            : .thinMaterial
    }
    
    private var shadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.3)
            : Color.black.opacity(0.1)
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .primary
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.8)
            : Color.secondary
    }
}

// MARK: - Large Widget (4x4)
struct LargePoemWidget: View {
    let poem: Poem
    @Environment(\.colorScheme) var colorScheme
    
    private var truncatedText: String {
        let limit = 600 // Aumentato molto
        if poem.poem.count <= limit {
            return poem.poem
        } else {
            let truncated = String(poem.poem.prefix(limit))
            if let lastSpace = truncated.lastIndex(of: " ") {
                return String(truncated[..<lastSpace]) + "..."
            }
            return truncated + "..."
        }
    }
    
    var body: some View {
        ZStack {
            // Solo background glass, NESSUNA cornice
            RoundedRectangle(cornerRadius: 24)
                .fill(glassBackground)
                .shadow(color: shadowColor, radius: 12, x: 0, y: 6)
            
            VStack(spacing: 12) {
                // Titolo solo se molto breve, altrimenti NIENTE
                if !poem.title.isEmpty && poem.title.count <= 20 {
                    Text(poem.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(primaryTextColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                }
                
                // TESTO POESIA - TUTTO LO SPAZIO
                Text(truncatedText)
                    .font(.body)
                    .foregroundStyle(primaryTextColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .lineLimit(poem.title.isEmpty || poem.title.count > 20 ? 16 : 15) // Massimo spazio
                
                Spacer()
                
                // SOLO autore
                Text(poem.author)
                    .font(.subheadline)
                    .foregroundStyle(secondaryTextColor)
                    .italic()
                    .fontWeight(.medium)
            }
            .padding(16) // Padding ridotto al minimo
        }
    }
    
    // MARK: - Glass Colors
    private var glassBackground: Material {
        colorScheme == .dark
            ? .ultraThinMaterial
            : .thinMaterial
    }
    
    private var shadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.4)
            : Color.black.opacity(0.08)
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .primary
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.85)
            : Color.secondary
    }
}

// MARK: - Extra Large Widget (4x8, iPad only)
struct ExtraLargePoemWidget: View {
    let poem: Poem
    @Environment(\.colorScheme) var colorScheme
    
    private var displayText: String {
        // Mostra TUTTO o quasi tutto
        let limit = 1000 // Limite molto alto
        if poem.poem.count <= limit {
            return poem.poem
        } else {
            let truncated = String(poem.poem.prefix(limit))
            if let lastSpace = truncated.lastIndex(of: " ") {
                return String(truncated[..<lastSpace]) + "..."
            }
            return truncated + "..."
        }
    }
    
    var body: some View {
        ZStack {
            // Solo background glass, NESSUNA cornice
            RoundedRectangle(cornerRadius: 28)
                .fill(glassBackground)
                .shadow(color: shadowColor, radius: 16, x: 0, y: 8)
            
            VStack(spacing: 16) {
                // Titolo solo se presente e breve
                if !poem.title.isEmpty && poem.title.count <= 30 {
                    Text(poem.title)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(primaryTextColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                
                // TESTO COMPLETO DELLA POESIA - PRIORITÀ ASSOLUTA
                Text(displayText)
                    .font(.title3)
                    .foregroundStyle(primaryTextColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .lineLimit(25) // Massimo spazio possibile
                
                Spacer()
                
                // SOLO autore e dedica minimalista
                VStack(spacing: 8) {
                    Text(poem.author)
                        .font(.title3)
                        .foregroundStyle(secondaryTextColor)
                        .italic()
                        .fontWeight(.medium)
                    
                    Text("💝 Per Chiara C.")
                        .font(.caption)
                        .foregroundStyle(secondaryTextColor.opacity(0.7))
                        .italic()
                }
            }
            .padding(18) // Padding ridotto
        }
    }
    
    // MARK: - Glass Colors
    private var glassBackground: Material {
        colorScheme == .dark
            ? .ultraThinMaterial
            : .thinMaterial
    }
    
    private var shadowColor: Color {
        colorScheme == .dark
            ? Color.black.opacity(0.5)
            : Color.black.opacity(0.06)
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .primary
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.9)
            : Color.secondary
    }
}

// MARK: - Widget Configuration
struct PillolePoeticheWidget: Widget {
    let kind: String = "PillolePoeticheWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PillolePoeticheWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Poesia del Momento")
        .description("Scopri bellissime poesie che si aggiornano ogni 4 ore. Disponibile in 3 dimensioni.")
        .supportedFamilies([.systemMedium, .systemLarge, .systemExtraLarge])
    }
}

#Preview(as: .systemMedium) {
    PillolePoeticheWidget()
} timeline: {
    PoemEntry(date: .now, poem: Poem.placeholder)
}

#Preview(as: .systemLarge) {
    PillolePoeticheWidget()
} timeline: {
    PoemEntry(date: .now, poem: Poem.placeholder)
}
