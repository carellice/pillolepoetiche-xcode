import SwiftUI

struct PoemCardView: View {
    let poem: Poem
    let horizontalPadding: CGFloat
    let isHorizontalScroll: Bool
    @State private var showShareConfirmation = false
    @State private var showFullPoem = false
    @State private var isGeneratingImage = false
    
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
                    .lineLimit(isHorizontalScroll ? 2 : nil)
            }
            
            // Testo della poesia
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
                    .lineLimit(1)
                
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
                    
                    // Pulsante condividi immagine
                    Button(action: sharePoem) {
                        Label("Condividi", systemImage: getShareIcon())
                            .labelStyle(.iconOnly)
                            .foregroundStyle(getShareColor())
                            .font(.title2)
                            .symbolEffect(.bounce, value: showShareConfirmation)
                            .opacity(isGeneratingImage ? 0.6 : 1.0)
                    }
                    .buttonStyle(.borderless)
                    .disabled(isGeneratingImage)
                }
            }
        }
        .padding(20)
        .frame(height: isHorizontalScroll ? fixedCardHeight : nil)
        .frame(maxWidth: .infinity, alignment: .topLeading)
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
    
    private func getShareIcon() -> String {
        if showShareConfirmation {
            return "checkmark.circle.fill"
        } else if isGeneratingImage {
            return "hourglass.circle"
        } else {
            return "square.and.arrow.up"
        }
    }
    
    private func getShareColor() -> Color {
        if showShareConfirmation {
            return .green
        } else {
            return .blue
        }
    }
    
    private func sharePoem() {
        isGeneratingImage = true
        
        ShareHelper.sharePoem(poem) { success in
            isGeneratingImage = false
            
            if success {
                // Feedback di successo
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showShareConfirmation = true
                }
                
                // Reset del checkmark dopo 2 secondi
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showShareConfirmation = false
                    }
                }
            }
        }
    }
}

struct FullPoemView: View {
    let poem: Poem
    @Environment(\.dismiss) private var dismiss
    @State private var showShareConfirmation = false
    @State private var isGeneratingImage = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Titolo della poesia (se presente)
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
                    
                    // Pulsante condividi immagine centrato
                    HStack {
                        Spacer()
                        Button(action: sharePoem) {
                            HStack(spacing: 8) {
                                if isGeneratingImage {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: showShareConfirmation ? "checkmark.circle.fill" : "square.and.arrow.up")
                                }
                                
                                Text(isGeneratingImage ? "Generando..." : (showShareConfirmation ? "Condiviso!" : "Condividi Immagine"))
                            }
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(showShareConfirmation ? .green : .blue)
                        .controlSize(.large)
                        .disabled(isGeneratingImage)
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
    
    private func sharePoem() {
        isGeneratingImage = true
        
        ShareHelper.sharePoem(poem) { success in
            isGeneratingImage = false
            
            if success {
                // Feedback di successo
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showShareConfirmation = true
                }
                
                // Reset del checkmark dopo 2 secondi
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showShareConfirmation = false
                    }
                }
            }
        }
    }
}

#Preview("Card con Condivisione Semplificata") {
    VStack {
        PoemCardView(
            poem: Poem(
                title: "Test Poesia",
                poem: "Questa è una poesia di test per vedere la nuova funzione di condivisione semplificata che genera solo un'immagine pulita.",
                author: "Autore Test"
            ),
            horizontalPadding: 16,
            isHorizontalScroll: false
        )
    }
    .padding()
    .background(Color(UIColor.systemBackground))
}
