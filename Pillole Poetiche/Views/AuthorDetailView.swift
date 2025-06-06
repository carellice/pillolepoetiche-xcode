import SwiftUI

// MARK: - AuthorDetailView originale (per iPhone)
struct AuthorDetailView: View {
    let author: String
    let poems: [Poem]
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    // Stato di caricamento
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Caricamento...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if poems.isEmpty {
                    // Nessuna poesia
                    ContentUnavailableView(
                        "Nessuna poesia",
                        systemImage: "doc.text",
                        description: Text("Non sono state trovate poesie per \(author)")
                    )
                } else {
                    // Contenuto normale
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            // Header con info autore
                            VStack(spacing: 16) {
                                // Avatar grande con immagine o iniziali
                                AuthorAvatarView(author: author, size: 80)
                                
                                VStack(spacing: 4) {
                                    Text(author)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.primary)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("\(poems.count) \(poems.count == 1 ? "poesia" : "poesie")")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 8)
                            
                            // Lista poesie
                            ForEach(poems) { poem in
                                PoemCardView(poem: poem, horizontalPadding: 16)
                            }
                        }
                        .padding(.bottom, 32)
                    }
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
            .navigationTitle(author)
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
            .onAppear {
                // Simula un breve caricamento per evitare il rendering vuoto
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isLoading = false
                    }
                }
            }
        }
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Vista iPad ottimizzata per autori (FIX: Una sola colonna)
struct iPadAuthorDetailView: View {
    let author: String
    let poems: [Poem]
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading = true
    @State private var selectedPoem: Poem?
    
    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Caricamento...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if poems.isEmpty {
                    ContentUnavailableView(
                        "Nessuna poesia",
                        systemImage: "doc.text",
                        description: Text("Non sono state trovate poesie per \(author)")
                    )
                } else {
                    iPadAuthorContent
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
            .navigationTitle(author)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        dismiss()
                    }
                    .foregroundStyle(.blue)
                    .fontWeight(.medium)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isLoading = false
                    }
                }
            }
            .sheet(item: Binding<PoemItem?>(
                get: { selectedPoem.map(PoemItem.init) },
                set: { selectedPoem = $0?.poem }
            )) { poemItem in
                iPadPoemDetailView(poem: poemItem.poem)
            }
        }
        .presentationDragIndicator(.visible)
    }
    
    @ViewBuilder
    private var iPadAuthorContent: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Header con info autore per iPad
                VStack(spacing: 24) {
                    AuthorAvatarView(author: author, size: 120)
                    
                    VStack(spacing: 8) {
                        Text(author)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                        
                        Text("\(poems.count) \(poems.count == 1 ? "poesia" : "poesie")")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .fontWeight(.medium)
                    }
                }
                .padding(.top, 40)
                
                // FIX: Layout a colonna singola invece di griglia
                LazyVStack(spacing: 24) {
                    ForEach(poems) { poem in
                        iPadAuthorPoemCard(poem: poem) {
                            selectedPoem = poem
                        }
                    }
                }
                .padding(.horizontal, 60) // FIX: Padding aumentato per card più strette ma più leggibili
                .padding(.bottom, 60)
            }
        }
    }
    
    // FIX: Card ancora più grandi per layout a colonna singola
    @ViewBuilder
    private func iPadAuthorPoemCard(poem: Poem, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 24) { // FIX: Spacing aumentato
                if !poem.title.isEmpty {
                    Text(poem.title)
                        .font(.title) // FIX: Font ancora più grande
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(4) // FIX: Più righe per il titolo
                }
                
                Text(poem.poem)
                    .font(.title2) // FIX: Font molto più grande
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(10) // FIX: Spaziatura ancora maggiore
                    .lineLimit(12) // FIX: Molte più righe disponibili
                
                Spacer()
                
                HStack {
                    Text("— \(poem.author)")
                        .font(.title3) // FIX: Font più grande per autore
                        .foregroundStyle(.tertiary)
                        .fontWeight(.medium)
                        .italic()
                    
                    Spacer()
                    
                    Label("Leggi tutto", systemImage: "arrow.up.right")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.blue)
                        .font(.title) // FIX: Icona molto più grande
                }
            }
            .padding(40) // FIX: Padding molto più generoso
            .frame(height: 280) // FIX: Altezza ottimizzata per singola colonna
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 24) // FIX: Corner radius più grande
                    .fill(.regularMaterial)
                    .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 6) // FIX: Shadow più pronunciata
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(.quaternary, lineWidth: 0.5)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Vista iPad per dettaglio poesia
struct iPadPoemDetailView: View {
    let poem: Poem
    @Environment(\.dismiss) private var dismiss
    @State private var showShareConfirmation = false
    @State private var isGeneratingImage = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // Contenuto centrato per iPad
                        VStack(alignment: .leading, spacing: 32) {
                            if !poem.title.isEmpty {
                                Text(poem.title)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Text(poem.poem)
                                .font(.title2)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                                .lineSpacing(12)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("— \(poem.author)")
                                .font(.title3)
                                .foregroundStyle(.tertiary)
                                .fontWeight(.medium)
                                .italic()
                            
                            // Pulsante condividi per iPad
                            HStack {
                                Spacer()
                                Button(action: sharePoem) {
                                    HStack(spacing: 12) {
                                        if isGeneratingImage {
                                            ProgressView()
                                                .scaleEffect(0.9)
                                        } else {
                                            Image(systemName: showShareConfirmation ? "checkmark.circle.fill" : "square.and.arrow.up")
                                        }
                                        
                                        Text(isGeneratingImage ? "Generando..." : (showShareConfirmation ? "Condiviso!" : "Condividi Immagine"))
                                    }
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                    .fontWeight(.medium)
                                }
                                .buttonStyle(.borderedProminent)
                                .tint(showShareConfirmation ? .green : .blue)
                                .controlSize(.large)
                                .disabled(isGeneratingImage)
                                Spacer()
                            }
                            .padding(.top, 16)
                        }
                        .frame(maxWidth: min(geometry.size.width * 0.7, 800))
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, max(40, (geometry.size.width - 800) / 2))
                    .padding(.vertical, 60)
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
            .navigationBarTitleDisplayMode(.large)
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
        .presentationDragIndicator(.visible)
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

#Preview("Light Mode - iPhone") {
    AuthorDetailView(
        author: "Charles Bukowski",
        poems: [
            Poem(title: "Test 1", poem: "Prima poesia di test lunga per vedere come viene visualizzata nel nuovo design iOS nativo", author: "Charles Bukowski"),
            Poem(title: "", poem: "Seconda poesia senza titolo", author: "Charles Bukowski"),
            Poem(title: "Poesia con titolo lungo", poem: "Terza poesia per testare il layout", author: "Charles Bukowski")
        ]
    )
    .preferredColorScheme(.light)
    .previewDevice("iPhone 15 Pro")
}

#Preview("Dark Mode - iPhone") {
    AuthorDetailView(
        author: "Charles Bukowski",
        poems: [
            Poem(title: "Test 1", poem: "Prima poesia di test lunga per vedere come viene visualizzata nel nuovo design iOS nativo", author: "Charles Bukowski"),
            Poem(title: "", poem: "Seconda poesia senza titolo", author: "Charles Bukowski"),
            Poem(title: "Poesia con titolo lungo", poem: "Terza poesia per testare il layout", author: "Charles Bukowski")
        ]
    )
    .preferredColorScheme(.dark)
    .previewDevice("iPhone 15 Pro")
}

#Preview("iPad Layout - Colonna Singola") {
    iPadAuthorDetailView(
        author: "Giacomo Leopardi",
        poems: [
            Poem(title: "L'infinito", poem: "Sempre caro mi fu quest'ermo colle, e questa siepe, che da tanta parte dell'ultimo orizzonte il guardo esclude. Ma sedendo e mirando, interminati spazi di là da quella, e sovrumani silenzi, e profondissima quiete io nel pensier mi fingo; ove per poco il cor non si spaura.", author: "Giacomo Leopardi"),
            Poem(title: "A Silvia", poem: "Silvia, rimembri ancora quel tempo della tua vita mortale, quando beltà splendea negli occhi tuoi ridenti e fuggitivi, e tu, lieta e pensosa, il limitare di gioventù salivi? Sonavan le quiete stanze, e le vie d'intorno, al tuo perpetuo canto, allor che all'opre femminili intenta sedevi, assai contenta di quel vago avvenir che in mente avevi.", author: "Giacomo Leopardi"),
            Poem(title: "La ginestra o il fiore del deserto", poem: "Qui su l'arida schiena del formidabil monte sterminator Vesevo, la qual null'altro allegra arbor né fiore, tuoi cespi solitari intorno spargi, odorata ginestra, contenta dei deserti. Anco ti vidi de' tuoi steli abbellir la erma contrada che cinge la cittade la qual fu donna de' mortali un tempo, e del perduto impero par che col grave e taciturno aspetto faccian fede e ricordanza al passeggero.", author: "Giacomo Leopardi"),
            Poem(title: "Il sabato del villaggio", poem: "La donzelletta vien dalla campagna, in sul calar del sole, col suo fascio dell'erba; e reca in mano un mazzolin di rose e di viole, onde, siccome suole, ornare ella si appresta dimane, al dì di festa, il petto e il crine. Siede con le vicine su la scala a filar la vecchierella, incontro là dove si perde il giorno; e novellando vien del suo buon tempo, quando ai dì della festa ella si ornava, ed ancor sana e snella solea danzar la sera intra di quei ch'ebbe compagni dell'età più bella.", author: "Giacomo Leopardi")
        ]
    )
    .previewDevice("iPad Pro (12.9-inch) (6th generation)")
    .previewDisplayName("iPad Pro - Colonna Singola Grande")
}
