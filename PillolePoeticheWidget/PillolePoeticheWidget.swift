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

// MARK: - Widget Entry View con supporto iPad ottimizzato
struct PillolePoeticheWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                if UIDevice.current.userInterfaceIdiom == .pad {
                    iPadMediumPoemWidget(poem: entry.poem)
                } else {
                    MediumPoemWidget(poem: entry.poem)
                }
            case .systemLarge:
                if UIDevice.current.userInterfaceIdiom == .pad {
                    iPadLargePoemWidget(poem: entry.poem)
                } else {
                    LargePoemWidget(poem: entry.poem)
                }
            case .systemExtraLarge:
                iPadExtraLargePoemWidget(poem: entry.poem)
            default:
                if UIDevice.current.userInterfaceIdiom == .pad {
                    iPadMediumPoemWidget(poem: entry.poem)
                } else {
                    MediumPoemWidget(poem: entry.poem)
                }
            }
        }
        .widgetURL(createWidgetURL(for: entry.poem))
    }
}

// MARK: - iPad Medium Widget (Ottimizzato)
struct iPadMediumPoemWidget: View {
    let poem: Poem
    @Environment(\.colorScheme) var colorScheme
    
    private var truncatedText: String {
        let limit = 500 // Più spazio su iPad
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
            // Background con effetto glass ottimizzato per iPad
            RoundedRectangle(cornerRadius: 24)
                .fill(glassBackground)
                .shadow(color: shadowColor, radius: 12, x: 0, y: 6)
            
            VStack(spacing: 12) {
                // Titolo se presente e breve
                if !poem.title.isEmpty && poem.title.count <= 30 {
                    Text(poem.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(primaryTextColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                
                // Testo della poesia
                Text(truncatedText)
                    .font(.body)
                    .foregroundStyle(primaryTextColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .lineLimit(poem.title.isEmpty || poem.title.count > 30 ? 12 : 10)
                
                Spacer()
                
                // Autore con stile iPad
                HStack {
                    Spacer()
                    Text("— \(poem.author)")
                        .font(.callout)
                        .foregroundStyle(secondaryTextColor)
                        .italic()
                        .fontWeight(.medium)
                    Spacer()
                }
            }
            .padding(18) // Padding maggiore per iPad
        }
    }
    
    // MARK: - Glass Effect Colors
    private var glassBackground: Material {
        colorScheme == .dark ? .ultraThinMaterial : .thinMaterial
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

// MARK: - iPad Large Widget (Ottimizzato)
struct iPadLargePoemWidget: View {
    let poem: Poem
    @Environment(\.colorScheme) var colorScheme
    
    private var displayText: String {
        let limit = 800 // Molto più spazio su iPad Large
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
            // Background glass per iPad
            RoundedRectangle(cornerRadius: 28)
                .fill(glassBackground)
                .shadow(color: shadowColor, radius: 16, x: 0, y: 8)
            
            VStack(spacing: 20) {
                // Titolo ottimizzato per iPad
                if !poem.title.isEmpty && poem.title.count <= 40 {
                    Text(poem.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(primaryTextColor)
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                }
                
                // Testo principale - priorità assoluta
                Text(displayText)
                    .font(.title3)
                    .foregroundStyle(primaryTextColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .lineLimit(poem.title.isEmpty || poem.title.count > 40 ? 20 : 17)
                
                Spacer()
                
                // Sezione autore e dedica per iPad
                VStack(spacing: 12) {
                    Text("— \(poem.author)")
                        .font(.title3)
                        .foregroundStyle(secondaryTextColor)
                        .italic()
                        .fontWeight(.medium)
                    
                    // Indicatore app per iPad
                    HStack(spacing: 8) {
                        Image(systemName: "quote.bubble.fill")
                            .font(.caption)
                            .foregroundStyle(tertiaryTextColor)
                        
                        Text("Pillole Poetiche")
                            .font(.caption)
                            .foregroundStyle(tertiaryTextColor)
                            .fontWeight(.medium)
                    }
                }
            }
            .padding(24) // Padding generoso per iPad
        }
    }
    
    // MARK: - Glass Effect Colors per iPad
    private var glassBackground: Material {
        colorScheme == .dark ? .ultraThinMaterial : .thinMaterial
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
    
    private var tertiaryTextColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.6)
            : Color(UIColor.tertiaryLabel)
    }
}

// MARK: - iPad Extra Large Widget (FIX: Rimozione ScrollView buggata)
struct iPadExtraLargePoemWidget: View {
    let poem: Poem
    @Environment(\.colorScheme) var colorScheme
    
    private var displayText: String {
        // Su Extra Large iPad mostriamo praticamente tutto
        let limit = 800 // FIX: Limite ridotto per evitare overflow
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
            // Background premium per Extra Large
            RoundedRectangle(cornerRadius: 32)
                .fill(glassBackground)
                .shadow(color: shadowColor, radius: 20, x: 0, y: 10)
            
            VStack(spacing: 24) { // FIX: Spacing ridotto
                // Header con titolo e decorazioni
                VStack(spacing: 12) { // FIX: Spacing ridotto
                    // Icona decorativa
                    Image(systemName: "quote.bubble.fill")
                        .font(.system(size: 28)) // FIX: Icona più piccola
                        .foregroundStyle(accentColor.opacity(0.8))
                    
                    // Titolo se presente
                    if !poem.title.isEmpty {
                        Text(poem.title)
                            .font(.title) // FIX: Font ridotto da largeTitle
                            .fontWeight(.bold)
                            .foregroundStyle(primaryTextColor)
                            .multilineTextAlignment(.center)
                            .lineLimit(3) // FIX: Limite righe ridotto
                    }
                }
                
                // FIX: Testo principale senza ScrollView (causa del bug evidenziazione)
                Text(displayText)
                    .font(.title3) // FIX: Font ridotto da title2
                    .foregroundStyle(primaryTextColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .lineLimit(15) // FIX: Limite di righe per evitare overflow
                    .padding(.horizontal, 16) // FIX: Padding orizzontale ridotto
                
                Spacer()
                
                // Footer elegante con autore e app info
                VStack(spacing: 12) { // FIX: Spacing ridotto
                    // Separatore decorativo
                    HStack {
                        Rectangle()
                            .fill(secondaryTextColor.opacity(0.3))
                            .frame(width: 50, height: 1) // FIX: Separatore più piccolo
                        
                        Circle()
                            .fill(secondaryTextColor.opacity(0.5))
                            .frame(width: 6, height: 6) // FIX: Cerchio più piccolo
                        
                        Rectangle()
                            .fill(secondaryTextColor.opacity(0.3))
                            .frame(width: 50, height: 1)
                    }
                    
                    // Autore prominente
                    Text("— \(poem.author)")
                        .font(.title2) // FIX: Font ridotto da title
                        .foregroundStyle(secondaryTextColor)
                        .italic()
                        .fontWeight(.medium)
                    
                    // App branding discreto ma elegante
                    VStack(spacing: 2) { // FIX: Spacing ridotto
                        Text("Pillole Poetiche")
                            .font(.callout) // FIX: Font ridotto da subheadline
                            .foregroundStyle(tertiaryTextColor)
                            .fontWeight(.semibold)
                        
                        Text("💝 Per Chiara C.")
                            .font(.caption2) // FIX: Font ridotto da caption
                            .foregroundStyle(tertiaryTextColor.opacity(0.8))
                            .italic()
                    }
                }
            }
            .padding(28) // FIX: Padding ridotto da 32
        }
    }
    
    // MARK: - Colors per Extra Large iPad
    private var glassBackground: Material {
        colorScheme == .dark ? .ultraThinMaterial : .thinMaterial
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
    
    private var tertiaryTextColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.7)
            : Color(UIColor.tertiaryLabel)
    }
    
    private var accentColor: Color {
        colorScheme == .dark ? .blue : .purple
    }
}

#Preview("iPad Extra Large - Fixed", as: .systemExtraLarge) {
    PillolePoeticheWidget()
} timeline: {
    PoemEntry(date: .now, poem: Poem(
        title: "Poesia Test Extra Large Fixed",
        poem: "Questa è una poesia di test per il widget Extra Large su iPad dopo le correzioni. Il testo ora non dovrebbe più avere parti evidenziate casualmente perché abbiamo rimosso la ScrollView che causava il problema. Il layout è ora più stabile e il testo viene visualizzato correttamente senza bug di rendering. La formattazione è ottimizzata per essere leggibile e ben proporzionata.",
        author: "Test Poeta Corretto"
    ))
}

// MARK: - Widget iPhone esistenti (mantenuti per compatibilità)

// Medium Widget iPhone (4x2) - Versione originale
struct MediumPoemWidget: View {
    let poem: Poem
    @Environment(\.colorScheme) var colorScheme
    
    private var truncatedText: String {
        let limit = 400
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
            RoundedRectangle(cornerRadius: 20)
                .fill(glassBackground)
                .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
            
            VStack(spacing: 6) {
                Text(truncatedText)
                    .font(.callout)
                    .foregroundStyle(primaryTextColor)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
                    .lineLimit(9)
                
                Spacer()
                
                Text("— \(poem.author)")
                    .font(.caption)
                    .foregroundStyle(secondaryTextColor)
                    .italic()
                    .fontWeight(.medium)
            }
            .padding(12)
        }
    }
    
    private var glassBackground: Material {
        colorScheme == .dark ? .ultraThinMaterial : .thinMaterial
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

// Large Widget iPhone (4x4) - Versione originale
struct LargePoemWidget: View {
    let poem: Poem
    @Environment(\.colorScheme) var colorScheme
    
    private var truncatedText: String {
        let limit = 600
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

// MARK: - Widget Configuration
struct PillolePoeticheWidget: Widget {
    let kind: String = "PillolePoeticheWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PillolePoeticheWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Poesia del Momento")
        .description("Scopri bellissime poesie che si aggiornano ogni 4 ore. Ottimizzato per iPhone e iPad.")
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

#Preview("iPad Medium", as: .systemMedium) {
    PillolePoeticheWidget()
} timeline: {
    PoemEntry(date: .now, poem: Poem(
        title: "Test iPad Medium",
        poem: "Questa è una poesia di test per vedere come viene visualizzata nel widget Medium su iPad con più spazio e font ottimizzati.",
        author: "Test Autore"
    ))
}

#Preview("iPad Large", as: .systemLarge) {
    PillolePoeticheWidget()
} timeline: {
    PoemEntry(date: .now, poem: Poem(
        title: "Test iPad Large",
        poem: "Questa è una poesia di test più lunga per vedere come viene visualizzata nel widget Large su iPad. Il testo dovrebbe avere più spazio e una formattazione migliore rispetto alla versione iPhone, con font più grandi e spaziature ottimizzate per schermi più grandi.",
        author: "Test Autore iPad"
    ))
}

#Preview("iPad Extra Large", as: .systemExtraLarge) {
    PillolePoeticheWidget()
} timeline: {
    PoemEntry(date: .now, poem: Poem(
        title: "Poesia Completa per iPad Extra Large",
        poem: "Questa è una poesia di test molto lunga per il widget Extra Large su iPad. Questo formato permette di mostrare poesie complete o quasi complete, con una formattazione elegante che include decorazioni, separatori e un layout premium che sfrutta tutto lo spazio disponibile. Il design è pensato per essere una vera e propria finestra poetica sulla home screen dell'iPad.",
        author: "Poeta di Test"
    ))
}
