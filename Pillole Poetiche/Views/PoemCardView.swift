import SwiftUI

struct PoemCardView: View {
    let poem: Poem
    let horizontalPadding: CGFloat
    let isHorizontalScroll: Bool
    @State private var showCopyConfirmation = false
    @State private var showFullPoem = false
    
    // CORREZIONE: Altezza fissa per le card del carousel
    private let fixedCardHeight: CGFloat = 280
    
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
            
            // CORREZIONE: Testo della poesia con gestione intelligente dello spazio
            if isHorizontalScroll {
                // Nel carousel, usiamo uno ScrollView interno per testi molto lunghi
                ScrollView {
                    Text(poem.poem)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(6)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxHeight: calculateTextHeight()) // Altezza dinamica basata sul contenuto disponibile
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
                    // Pulsante "Leggi tutto" sempre presente nel carousel
                    if isHorizontalScroll {
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
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, horizontalPadding)
        .contentShape(Rectangle())
        .onTapGesture {
            if isHorizontalScroll {
                showFullPoem = true
            }
        }
        .sheet(isPresented: $showFullPoem) {
            FullPoemView(poem: poem)
                .presentationDragIndicator(.visible)
        }
    }
    
    // CORREZIONE: Calcola l'altezza massima disponibile per il testo nel carousel
    private func calculateTextHeight() -> CGFloat {
        let titleHeight: CGFloat = poem.title.isEmpty ? 0 : 50 // Stima altezza titolo
        let authorHeight: CGFloat = 40 // Stima altezza sezione autore/pulsanti
        let padding: CGFloat = 56 // Padding totale (20 * 2 + spacing)
        let spacing: CGFloat = 32 // Spacing tra elementi (16 * 2)
        
        return fixedCardHeight - titleHeight - authorHeight - padding - spacing
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

#Preview("Card Carousel - Altezza Fissa") {
    ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 16) {
            // Poesia corta
            PoemCardView(
                poem: Poem(
                    title: "Breve",
                    poem: "Testo breve che viene visualizzato in una card di altezza fissa.",
                    author: "Autore"
                ),
                horizontalPadding: 0,
                isHorizontalScroll: true
            )
            .frame(width: 300)
            
            // Poesia media
            PoemCardView(
                poem: Poem(
                    title: "Media",
                    poem: "Questo è un testo di media lunghezza che dovrebbe adattarsi bene alla card di altezza fissa senza creare problemi di sovrapposizione con altri elementi dell'interfaccia.",
                    author: "Autore Test"
                ),
                horizontalPadding: 0,
                isHorizontalScroll: true
            )
            .frame(width: 300)
            
            // Poesia lunga
            PoemCardView(
                poem: Poem(
                    title: "Lunga con titolo molto lungo che potrebbe andare su più righe",
                    poem: "Questo è un testo molto lungo che prima causava problemi di sovrapposizione. Ora con l'altezza fissa e lo ScrollView interno, il testo si adatta perfettamente senza interferire con altri elementi. L'utente può scorrere per leggere tutto il contenuto all'interno della card oppure toccare per aprire la vista completa. Questo approccio risolve il problema delle card che si compenetravano con la scritta 'Scorri poesie' e mantiene un layout pulito e consistente. Il testo continua qui per testare come si comporta lo scroll interno quando abbiamo davvero molto contenuto da visualizzare. La card mantiene sempre la stessa altezza indipendentemente dalla lunghezza del contenuto.",
                    author: "Autore con Nome Molto Lungo"
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
