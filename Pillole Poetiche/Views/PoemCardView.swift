import SwiftUI

struct PoemCardView: View {
    let poem: Poem
    let horizontalPadding: CGFloat
    let isHorizontalScroll: Bool
    @State private var showShareConfirmation = false
    @State private var showFullPoem = false
    @State private var isGeneratingImage = false
    
    // Altezza fissa per le card del carousel
    private let fixedCardHeight: CGFloat = 280
    private let iPadFixedCardHeight: CGFloat = 320
    
    // Computed property per il testo troncato con limiti diversi per iPad
    private var truncatedText: String {
        let characterLimit: Int
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Su iPad abbiamo più spazio
            characterLimit = poem.title.isEmpty ? 280 : 220
        } else {
            // iPhone mantiene i limiti originali
            characterLimit = poem.title.isEmpty ? 210 : 162
        }
        
        if poem.poem.count <= characterLimit {
            return poem.poem
        } else {
            let truncated = String(poem.poem.prefix(characterLimit))
            return truncated + "..."
        }
    }
    
    // Computed property per verificare se il testo è troncato
    private var isTextTruncated: Bool {
        let characterLimit: Int
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            characterLimit = poem.title.isEmpty ? 280 : 220
        } else {
            characterLimit = poem.title.isEmpty ? 210 : 162
        }
        
        return poem.poem.count > characterLimit
    }
    
    init(poem: Poem, horizontalPadding: CGFloat = 16, isHorizontalScroll: Bool = false) {
        self.poem = poem
        self.horizontalPadding = horizontalPadding
        self.isHorizontalScroll = isHorizontalScroll
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: iPadSpacing) {
            // Titolo (se presente)
            if !poem.title.isEmpty {
                Text(poem.title)
                    .font(iPadTitleFont)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(isHorizontalScroll ? 2 : nil)
            }
            
            // Testo della poesia
            if isHorizontalScroll {
                Text(truncatedText)
                    .font(iPadBodyFont)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(iPadLineSpacing)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text(poem.poem)
                    .font(iPadBodyFont)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(iPadLineSpacing)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            if isHorizontalScroll {
                Spacer()
            }
            
            // Autore e pulsanti
            HStack {
                Text("— \(poem.author)")
                    .font(iPadAuthorFont)
                    .foregroundStyle(.tertiary)
                    .fontWeight(.medium)
                    .italic()
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: iPadButtonSpacing) {
                    // Pulsante "Espandi" se il testo è troncato
                    if isHorizontalScroll && isTextTruncated {
                        Button(action: { showFullPoem = true }) {
                            Label("Espandi", systemImage: "arrow.up.left.and.arrow.down.right")
                                .labelStyle(.iconOnly)
                                .foregroundStyle(.blue)
                                .font(iPadButtonFont)
                        }
                        .buttonStyle(.borderless)
                    }
                    
                    // Pulsante condividi immagine
                    Button(action: sharePoem) {
                        Label("Condividi", systemImage: getShareIcon())
                            .labelStyle(.iconOnly)
                            .foregroundStyle(getShareColor())
                            .font(iPadShareButtonFont)
                            .symbolEffect(.bounce, value: showShareConfirmation)
                            .opacity(isGeneratingImage ? 0.6 : 1.0)
                    }
                    .buttonStyle(.borderless)
                    .disabled(isGeneratingImage)
                }
            }
        }
        .padding(iPadPadding)
        .frame(height: isHorizontalScroll ? cardHeight : nil)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: iPadCornerRadius)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: iPadShadowRadius, x: 0, y: iPadShadowY)
                .overlay(
                    RoundedRectangle(cornerRadius: iPadCornerRadius)
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
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadPoemDetailView(poem: poem)
            } else {
                FullPoemView(poem: poem)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    // MARK: - Responsive Design Properties
    
    private var iPadSpacing: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
    }
    
    private var iPadPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 24 : 20
    }
    
    private var iPadCornerRadius: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 20 : 16
    }
    
    private var iPadShadowRadius: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 8 : 6
    }
    
    private var iPadShadowY: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 4 : 3
    }
    
    private var iPadLineSpacing: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 8 : 6
    }
    
    private var iPadButtonSpacing: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 16 : 12
    }
    
    private var cardHeight: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? iPadFixedCardHeight : fixedCardHeight
    }
    
    // MARK: - Responsive Fonts
    
    private var iPadTitleFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .title3
    }
    
    private var iPadBodyFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .body : .body
    }
    
    private var iPadAuthorFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .callout : .subheadline
    }
    
    private var iPadButtonFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .title3
    }
    
    private var iPadShareButtonFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .title : .title2
    }
    
    // MARK: - Helper Functions
    
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
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showShareConfirmation = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showShareConfirmation = false
                    }
                }
            }
        }
    }
}

// MARK: - FullPoemView con ottimizzazioni iPad
struct FullPoemView: View {
    let poem: Poem
    @Environment(\.dismiss) private var dismiss
    @State private var showShareConfirmation = false
    @State private var isGeneratingImage = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: responsiveSpacing) {
                        // Contenuto responsive
                        VStack(alignment: .leading, spacing: responsiveContentSpacing) {
                            // Titolo della poesia (se presente)
                            if !poem.title.isEmpty {
                                Text(poem.title)
                                    .font(responsiveTitleFont)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            // Testo completo
                            Text(poem.poem)
                                .font(responsiveBodyFont)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(responsiveLineSpacing)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            // Autore
                            Text("— \(poem.author)")
                                .font(responsiveAuthorFont)
                                .foregroundStyle(.tertiary)
                                .fontWeight(.medium)
                                .italic()
                            
                            // Pulsante condividi centrato
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
                                    .font(responsiveButtonFont)
                                    .fontWeight(.medium)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(showShareConfirmation ? .green : .blue)
                                .controlSize(responsiveControlSize)
                                .disabled(isGeneratingImage)
                                Spacer()
                            }
                            .padding(.top, responsiveButtonTopPadding)
                        }
                        .frame(maxWidth: maxContentWidth(geometry: geometry))
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, responsiveHorizontalPadding(geometry: geometry))
                    .padding(.vertical, responsiveVerticalPadding)
                }
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
            .navigationBarTitleDisplayMode(UIDevice.current.userInterfaceIdiom == .pad ? .large : .inline)
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
    
    // MARK: - Responsive Design Properties
    
    private var responsiveSpacing: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 40 : 24
    }
    
    private var responsiveContentSpacing: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 32 : 24
    }
    
    private var responsiveLineSpacing: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 12 : 8
    }
    
    private var responsiveButtonTopPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 24 : 8
    }
    
    private var responsiveVerticalPadding: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 60 : 24
    }
    
    // MARK: - Responsive Fonts
    
    private var responsiveTitleFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .largeTitle : .title2
    }
    
    private var responsiveBodyFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .title2 : .body
    }
    
    private var responsiveAuthorFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .title3 : .subheadline
    }
    
    private var responsiveButtonFont: Font {
        UIDevice.current.userInterfaceIdiom == .pad ? .headline : .subheadline
    }
    
    private var responsiveControlSize: ControlSize {
        UIDevice.current.userInterfaceIdiom == .pad ? .large : .regular
    }
    
    // MARK: - Responsive Layout
    
    private func maxContentWidth(geometry: GeometryProxy) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return min(geometry.size.width * 0.7, 800)
        } else {
            return .infinity
        }
    }
    
    private func responsiveHorizontalPadding(geometry: GeometryProxy) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return max(40, (geometry.size.width - 800) / 2)
        } else {
            return 24
        }
    }
    
    private func sharePoem() {
        isGeneratingImage = true
        
        ShareHelper.sharePoem(poem) { success in
            isGeneratingImage = false
            
            if success {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    showShareConfirmation = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showShareConfirmation = false
                    }
                }
            }
        }
    }
}

#Preview("iPad Card") {
    VStack {
        PoemCardView(
            poem: Poem(
                title: "Test Poesia per iPad",
                poem: "Questa è una poesia di test per vedere come viene visualizzata nel nuovo design iPad ottimizzato con font più grandi e spaziature migliori.",
                author: "Autore Test"
            ),
            horizontalPadding: 24,
            isHorizontalScroll: false
        )
    }
    .padding()
    .background(Color(UIColor.systemBackground))
    .previewDevice("iPad Pro (12.9-inch) (6th generation)")
}

#Preview("iPhone Card") {
    VStack {
        PoemCardView(
            poem: Poem(
                title: "Test Poesia",
                poem: "Questa è una poesia di test per iPhone.",
                author: "Autore Test"
            ),
            horizontalPadding: 16,
            isHorizontalScroll: false
        )
    }
    .padding()
    .background(Color(UIColor.systemBackground))
    .previewDevice("iPhone 15 Pro")
}
