import SwiftUI

struct PoemCardView: View {
    let poem: Poem
    let horizontalPadding: CGFloat
    let isHorizontalScroll: Bool
    @State private var showCopyConfirmation = false
    @State private var showFullPoem = false
    
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
            }
            
            // Testo della poesia con truncation manuale per carousel
            if isHorizontalScroll {
                Text(truncatedText)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text(poem.poem)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Autore e pulsanti
            HStack {
                Text("— \(poem.author)")
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                    .fontWeight(.medium)
                    .italic()
                
                Spacer()
                
                HStack(spacing: 12) {
                    // Pulsante "Leggi tutto" solo nel carousel se il testo è troncato
                    if isHorizontalScroll && poem.poem.count > 110 {
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
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, horizontalPadding)
        .contentShape(Rectangle())
        .onTapGesture {
            if isHorizontalScroll && poem.poem.count > 110 {
                showFullPoem = true
            }
        }
        .sheet(isPresented: $showFullPoem) {
            FullPoemView(poem: poem)
                .presentationDragIndicator(.visible)
        }
    }
    
    // Computed property per il testo troncato
    private var truncatedText: String {
        if poem.poem.count <= 110 {
            return poem.poem
        } else {
            let truncated = String(poem.poem.prefix(110))
            return truncated + "..."
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
                poem: "Questa è una poesia di test per vedere come viene visualizzata nella card.",
                author: "Autore Test"
            ),
            horizontalPadding: 16,
            isHorizontalScroll: false
        )
    }
    .padding()
    .background(Color(UIColor.systemBackground))
}

#Preview("Card Carousel - Testo Troncato") {
    VStack(spacing: 20) {
        // Poesia corta (non troncata)
        PoemCardView(
            poem: Poem(
                title: "Breve",
                poem: "Testo breve che non viene troncato perché ha meno di 110 caratteri.",
                author: "Autore"
            ),
            horizontalPadding: 16,
            isHorizontalScroll: true
        )
        
        // Poesia lunga (troncata)
        PoemCardView(
            poem: Poem(
                title: "Lunga",
                poem: "Questo è un testo molto lungo che supera i 110 caratteri e dovrebbe essere troncato esattamente al centodecimo carattere con tre puntini per indicare che c'è altro testo da leggere. Questo testo è abbastanza lungo da testare la funzionalità.",
                author: "Autore Test"
            ),
            horizontalPadding: 16,
            isHorizontalScroll: true
        )
    }
    .padding()
    .background(Color(UIColor.systemBackground))
}

#Preview("Sheet Poesia Completa") {
    FullPoemView(
        poem: Poem(
            title: "Poesia Completa",
            poem: "Questa è la vista completa della poesia che si apre quando si tocca una card troncata. Il testo è mostrato per intero con una formattazione ottimizzata per la lettura. Il pulsante di copia è ora centrato e ben visibile.",
            author: "Autore Esempio"
        )
    )
}
