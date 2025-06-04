import SwiftUI

struct PoemCardView: View {
    let poem: Poem
    let horizontalPadding: CGFloat
    let isHorizontalScroll: Bool
    @State private var showCopyConfirmation = false
    @State private var showFullPoem = false
    
    // CORREZIONE: Altezza fissa per le card del carousel
    private let fixedCardHeight: CGFloat = 280
    
    // CORREZIONE: Computed property per il testo troncato con limiti diversi
    private var truncatedText: String {
        // Limite diverso a seconda se c'è il titolo o no
        let characterLimit = poem.title.isEmpty ? 210 : 162
        
        if poem.poem.count <= characterLimit {
            return poem.poem
        } else {
            let truncated = String(poem.poem.prefix(characterLimit))
            return truncated + "..."
        }
    }
    
    // Computed property per verificare se il testo è troncato
    private var isTextTruncated: Bool {
        let characterLimit = poem.title.isEmpty ? 210 : 162
        return poem.poem.count > characterLimit
    }
    
    init(poem: Poem, horizontalPadding: CGFloat = 16, isHorizontalScroll: Bool = false) {
        self.poem = poem
        self.horizontalPadding = horizontalPadding
        self.isHorizontalScroll = isHorizontalScroll
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Titolo (se presente)
            if !poem.title.isEmpty {
                Text(poem.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(isHorizontalScroll ? 2 : nil) // Limita il titolo nel carousel
            }
            
            // CORREZIONE: Testo della poesia con troncamento fisso per il carousel
            if isHorizontalScroll {
                // Nel carousel, tronchiamo a 162 caratteri senza ScrollView
                Text(truncatedText)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                // Card normale senza limitazioni
                Text(poem.poem)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // CORREZIONE: Spacer per spingere l'autore e i pulsanti in basso nelle card del carousel
            if isHorizontalScroll {
                Spacer()
            }
            
            // Autore e pulsanti
            HStack {
                Text("— \(poem.author)")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .fontWeight(.medium)
                    .italic()
                    .lineLimit(1) // Evita che l'autore vada su più righe
                
                Spacer()
                
                HStack(spacing: 12) {
                    // Pulsante "Espandi" se il testo è troncato
                    if isHorizontalScroll && isTextTruncated {
                        Button(action: { showFullPoem = true }) {
                            Label("Espandi", systemImage: "arrow.up.left.and.arrow.down.right")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.blue)
                                .font(.title3)
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    // Pulsante copia
                    Button(action: copyPoem) {
                        Label("Copia", systemImage: showCopyConfirmation ? "checkmark.circle.fill" : "doc.on.doc")
                            .labelStyle(.iconOnly)
                            .foregroundStyle(showCopyConfirmation ? .green : .blue)
                            .font(.title2)
                            .symbolEffect(.bounce, value: showCopyConfirmation)
                    }
                    .buttonStyle(.borderless)
                }
            }
        }
        .padding(20)
        .frame(height: isHorizontalScroll ? fixedCardHeight : nil) // CORREZIONE: Altezza fissa solo per il carousel
        .frame(maxWidth: .infinity, alignment: .topLeading) // Allineamento in alto a sinistra
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.quaternary, lineWidth: 0.5)
                )
        )
        .padding(.horizontal, horizontalPadding)
        .contentShape(Rectangle())
        .onTapGesture {
            if isHorizontalScroll && isTextTruncated {
                showFullPoem = true
            }
        }
        .sheet(isPresented: $showFullPoem) {
            FullPoemView(poem: poem)
                .presentationDragIndicator(.visible)
        }
    }
    
    private func copyPoem() {
        UIPasteboard.general.string = poem.shareText
        
        // Feedback visivo
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showCopyConfirmation = true
        }
        
        // Feedback aptico
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Reset del checkmark dopo 2 secondi
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut(duration: 0.3)) {
                showCopyConfirmation = false
            }
        }
    }
}

struct FullPoemView: View {
    let poem: Poem
    @Environment(\.dismiss) private var dismiss
    @State private var showCopyConfirmation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Titolo (se presente)
                    if !poem.title.isEmpty {
                        Text(poem.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    // Testo completo
                    Text(poem.poem)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Autore
                    Text("— \(poem.author)")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                        .fontWeight(.medium)
                        .italic()
                    
                    // Pulsante copia centrato
                    HStack {
                        Spacer()
                        Button(action: copyPoem) {
                            Label(
                                showCopyConfirmation ? "Copiato!" : "Copia poesia",
                                systemImage: showCopyConfirmation ? "checkmark.circle.fill" : "doc.on.doc"
                            )
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(showCopyConfirmation ? .green : .blue)
                        .controlSize(.large)
                        Spacer()
                    }
                    .padding(.top, 8)
                }
                .padding(24)
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
            .navigationTitle("Poesia completa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                    .foregroundStyle(.blue)
                    .fontWeight(.medium)
                }
            }
        }
    }
    
    private func copyPoem() {
        UIPasteboard.general.string = poem.shareText
        
        // Feedback visivo
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            showCopyConfirmation = true
        }
        
        // Feedback aptico
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Reset del checkmark dopo 2 secondi
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut(duration: 0.3)) {
                showCopyConfirmation = false
            }
        }
    }
}

#Preview("Card Normale") {
    VStack {
        PoemCardView(
            poem: Poem(
                title: "Test Poesia",
                poem: "Questa è una poesia di test per vedere come viene visualizzata nella card normale senza limitazioni di altezza.",
                author: "Autore Test"
            ),
            horizontalPadding: 16,
            isHorizontalScroll: false
        )
    }
    .padding()
    .background(Color(UIColor.systemBackground))
}

#Preview("Card Carousel - Troncamento Intelligente") {
    ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 16) {
            // Poesia CON titolo - limite 162 caratteri
            PoemCardView(
                poem: Poem(
                    title: "Con Titolo",
                    poem: "Questa poesia ha un titolo, quindi viene troncata a 162 caratteri. Questo testo è abbastanza lungo da superare il limite di 162 caratteri e dovrebbe essere troncato con tre puntini per mostrare che c'è altro contenuto da leggere nella vista completa.",
                    author: "Autore Test"
                ),
                horizontalPadding: 0,
                isHorizontalScroll: true
            )
            .frame(width: 300)
            
            // Poesia SENZA titolo - limite 210 caratteri
            PoemCardView(
                poem: Poem(
                    title: "",
                    poem: "Questa poesia non ha titolo, quindi viene troncata a 210 caratteri. Avendo più spazio disponibile (senza il titolo), può contenere molto più testo prima di essere troncata. Questo permette di sfruttare meglio lo spazio della card quando non c'è un titolo da mostrare. Il limite è molto più alto per ottimizzare l'esperienza di lettura e permettere di vedere più contenuto direttamente nella card del carousel.",
                    author: "Autore Senza Titolo"
                ),
                horizontalPadding: 0,
                isHorizontalScroll: true
            )
            .frame(width: 300)
            
            // Poesia breve CON titolo (non troncata)
            PoemCardView(
                poem: Poem(
                    title: "Breve",
                    poem: "Testo breve che non viene troncato.",
                    author: "Autore"
                ),
                horizontalPadding: 0,
                isHorizontalScroll: true
            )
            .frame(width: 300)
            
            // Poesia breve SENZA titolo (non troncata)
            PoemCardView(
                poem: Poem(
                    title: "",
                    poem: "Testo breve senza titolo che non viene troncato perché è sotto il limite di 210 caratteri per le poesie senza titolo.",
                    author: "Autore"
                ),
                horizontalPadding: 0,
                isHorizontalScroll: true
            )
            .frame(width: 300)
        }
        .padding(.horizontal, 16)
    }
    .background(Color(UIColor.systemBackground))
}

#Preview("Sheet Poesia Completa") {
    FullPoemView(
        poem: Poem(
            title: "Poesia Completa",
            poem: "Questa è la vista completa della poesia che si apre quando si tocca una card o si preme il pulsante espandi. Il testo è mostrato per intero con una formattazione ottimizzata per la lettura. Il pulsante di copia è centrato e ben visibile.",
            author: "Autore Esempio"
        )
    )
}
