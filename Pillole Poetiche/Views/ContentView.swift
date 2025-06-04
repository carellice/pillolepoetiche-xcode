import SwiftUI

struct ContentView: View {
    @StateObject private var poemsData = PoemsData()
    @State private var randomPoem: Poem?
    @State private var shuffledPoems: [Poem] = []
    @State private var searchText = ""
    @State private var selectedAuthor: String?
    @State private var showAuthorSheet = false
    @State private var rotationAngle: Double = 0
    @State private var isDataLoaded = false
    
    var filteredAuthors: [String] {
        let authors = poemsData.getUniqueAuthors()
        if searchText.isEmpty {
            return authors
        } else {
            return authors.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    // Indicatore debug dei dati caricati (rimuovi dopo il test)
                    if !isDataLoaded {
                        HStack {
                            ProgressView()
                                .scaleEffect(0.8)
                            Text("Caricamento dati...")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal, 16)
                    }
                    
                    // Sezione Poesia Casuale
                    VStack(spacing: 20) {
                        SectionHeaderView(
                            title: "Poesia casuale",
                            systemImage: "quote.bubble",
                            action: {
                                refreshRandomPoem()
                            },
                            actionIcon: "arrow.clockwise",
                            rotationAngle: rotationAngle
                        )
                        
                        if let poem = randomPoem {
                            PoemCardView(poem: poem, horizontalPadding: 16)
                        }
                    }
                    
                    // Sezione Scorri le poesie
                    VStack(spacing: 20) {
                        SectionHeaderView(
                            title: "Scorri le poesie",
                            systemImage: "books.vertical"
                        )
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 16) {
                                ForEach(shuffledPoems) { poem in
                                    PoemCardView(poem: poem, horizontalPadding: 0, isHorizontalScroll: true)
                                        .frame(width: UIScreen.main.bounds.width - 32)
                                        .scrollTransition { content, phase in
                                            content
                                                .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                                .opacity(phase.isIdentity ? 1 : 0.8)
                                        }
                                }
                            }
                            .scrollTargetLayout()
                            .padding(.horizontal, 16)
                        }
                        .scrollTargetBehavior(.viewAligned)
                        .scrollClipDisabled()
                    }
                    
                    // Sezione Poesie per autore
                    VStack(spacing: 20) {
                        SectionHeaderView(
                            title: "Poesie per autore",
                            systemImage: "person.2"
                        )
                        
                        // Barra di ricerca iOS nativa
                        VStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.secondary)
                                
                                TextField("Cerca autore...", text: $searchText)
                                    .textFieldStyle(.plain)
                                
                                if !searchText.isEmpty {
                                    Button(action: { searchText = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                            .padding(.horizontal, 16)
                        }
                        
                        // Lista autori
                        if filteredAuthors.isEmpty {
                            ContentUnavailableView(
                                "Nessun risultato",
                                systemImage: "magnifyingglass",
                                description: Text("Prova a cercare con un altro termine")
                            )
                            .padding()
                        } else {
                            LazyVStack(spacing: 0) {
                                ForEach(Array(filteredAuthors.enumerated()), id: \.element) { index, author in
                                    AuthorRowView(
                                        author: author,
                                        poemCount: poemsData.getAuthorCount(author),
                                        isLast: index == filteredAuthors.count - 1
                                    ) {
                                        selectedAuthor = author
                                        showAuthorSheet = true
                                    }
                                }
                            }
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal, 16)
                        }
                    }
                    
                    // Footer con design iOS
                    VStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                            .font(.title2)
                        
                        Text("Creato da F.C. per Chiara C.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                }
                .padding(.top, 8)
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
            .navigationTitle("Pillole Poetiche")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            setupInitialData()
        }
        .sheet(isPresented: $showAuthorSheet, onDismiss: {
            // Reset quando lo sheet si chiude
            selectedAuthor = nil
        }) {
            if let author = selectedAuthor, isDataLoaded {
                let authorPoems = poemsData.getPoemsByAuthor(author)
                if !authorPoems.isEmpty {
                    AuthorDetailView(
                        author: author,
                        poems: authorPoems
                    )
                } else {
                    // Fallback se non ci sono poesie
                    NavigationStack {
                        ContentUnavailableView(
                            "Nessuna poesia trovata",
                            systemImage: "doc.text",
                            description: Text("Non sono state trovate poesie per \(author)")
                        )
                        .navigationTitle(author)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Chiudi") {
                                    dismissSheet()
                                }
                                .foregroundStyle(.blue)
                                .fontWeight(.medium)
                            }
                        }
                    }
                    .presentationDragIndicator(.visible)
                }
            } else {
                // Fallback se selectedAuthor è nil o dati non caricati
                NavigationStack {
                    ContentUnavailableView(
                        "Caricamento in corso",
                        systemImage: "hourglass",
                        description: Text("I dati stanno ancora caricando, riprova tra un momento")
                    )
                    .navigationTitle("Caricamento")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Chiudi") {
                                dismissSheet()
                            }
                            .foregroundStyle(.blue)
                            .fontWeight(.medium)
                        }
                    }
                }
                .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func setupInitialData() {
        // Verifica che PoemsData abbia i dati
        let totalPoems = poemsData.poems.count
        let totalAuthors = poemsData.getUniqueAuthors().count
        
        print("📊 Setup iniziale:")
        print("   - Poesie totali: \(totalPoems)")
        print("   - Autori totali: \(totalAuthors)")
        
        // Carica immediatamente i dati all'apertura
        randomPoem = poemsData.getRandomPoem()
        shuffledPoems = poemsData.getShuffledPoems()
        
        print("   - Poesia casuale: \(randomPoem?.title ?? "Nessuna")")
        print("   - Poesie shuffle: \(shuffledPoems.count)")
        
        // Marca i dati come caricati immediatamente solo se ci sono davvero dati
        if totalPoems > 0 && totalAuthors > 0 {
            isDataLoaded = true
            print("✅ Dati caricati con successo!")
        } else {
            print("❌ Errore: Nessun dato trovato!")
            // Riprova dopo un breve delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                setupInitialData()
            }
        }
    }
    
    private func refreshRandomPoem() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            randomPoem = poemsData.getRandomPoem()
        }
        
        withAnimation(.easeInOut(duration: 0.8)) {
            rotationAngle += 360
        }
        
        // Feedback aptico
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func dismissSheet() {
        showAuthorSheet = false
        // Reset selectedAuthor dopo una breve pausa per evitare problemi di timing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            selectedAuthor = nil
        }
    }
}

struct SectionHeaderView: View {
    let title: String
    let systemImage: String
    var action: (() -> Void)? = nil
    var actionIcon: String? = nil
    var rotationAngle: Double = 0
    
    var body: some View {
        HStack {
            Label(title, systemImage: systemImage)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Spacer()
            
            if let action = action, let actionIcon = actionIcon {
                Button(action: action) {
                    Image(systemName: actionIcon)
                        .font(.title2)
                        .foregroundStyle(.blue)
                        .rotationEffect(.degrees(rotationAngle))
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct AuthorRowView: View {
    let author: String
    let poemCount: Int
    let isLast: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Avatar con immagine o iniziali
                AuthorAvatarView(author: author, size: 40)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(author)
                        .foregroundStyle(.primary)
                        .font(.body)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(poemCount) \(poemCount == 1 ? "poesia" : "poesie")")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(poemCount == 0) // Disabilita se non ci sono poesie
        .opacity(poemCount == 0 ? 0.6 : 1.0) // Rendi visivamente disabilitato
        
        if !isLast {
            Divider()
                .padding(.leading, 68)
        }
    }
}

#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
