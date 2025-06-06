import SwiftUI

// Struct per gestire il binding dello sheet con item
struct AuthorItem: Identifiable {
    let id = UUID()
    let name: String
}

struct PoemItem: Identifiable {
    let id = UUID()
    let poem: Poem
}

struct ContentView: View {
    @StateObject private var poemsData = PoemsData()
    @State private var randomPoem: Poem?
    @State private var shuffledPoems: [Poem] = []
    @State private var searchText = ""
    @State private var selectedAuthor: String?
    @State private var selectedAuthorItem: AuthorItem?
    @State private var rotationAngle: Double = 0
    @State private var isDataLoaded = false
    @State private var selectedPoem: Poem?
    
    var filteredAuthors: [String] {
        let authors = poemsData.getUniqueAuthors()
        if searchText.isEmpty {
            return authors
        } else {
            return authors.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                // FIX: iPad senza NavigationStack per evitare problemi di header
                iPadLayoutWithoutNavigation
            } else {
                // iPhone mantiene NavigationStack normale
                NavigationStack {
                    iPhoneLayout
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
            }
        }
        .onAppear {
            setupInitialData()
        }
        .sheet(item: $selectedAuthorItem, onDismiss: {
            selectedAuthor = nil
        }) { authorItem in
            let authorPoems = poemsData.getPoemsByAuthor(authorItem.name)
            
            if !authorPoems.isEmpty {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    iPadAuthorDetailView(
                        author: authorItem.name,
                        poems: authorPoems
                    )
                } else {
                    AuthorDetailView(
                        author: authorItem.name,
                        poems: authorPoems
                    )
                }
            } else {
                fallbackAuthorView(authorName: authorItem.name)
            }
        }
        .sheet(item: Binding<PoemItem?>(
            get: { selectedPoem.map(PoemItem.init) },
            set: { selectedPoem = $0?.poem }
        )) { poemItem in
            if UIDevice.current.userInterfaceIdiom == .pad {
                iPadPoemDetailView(poem: poemItem.poem)
            } else {
                FullPoemView(poem: poemItem.poem)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    // MARK: - iPad Layout senza NavigationStack
    @ViewBuilder
    private var iPadLayoutWithoutNavigation: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // FIX: Header fisso personalizzato per iPad
                iPadCustomHeader()
                
                // Layout principale
                HStack(spacing: 0) {
                    // Sidebar Sinistra - Autori (30% della larghezza)
                    iPadSidebar(width: geometry.size.width * 0.3)
                    
                    Divider()
                        .background(.quaternary)
                    
                    // Contenuto Principale - Poesie (70% della larghezza)
                    iPadMainContent(width: geometry.size.width * 0.7)
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
    }
    
    // FIX: Header personalizzato fisso per iPad
    @ViewBuilder
    private func iPadCustomHeader() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Pillole Poetiche")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text("Una collezione di poesie per l'anima")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            // Icona decorativa
            Image(systemName: "quote.bubble.fill")
                .font(.title)
                .foregroundStyle(.blue.opacity(0.7))
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 20)
        .background(.regularMaterial)
        .overlay(
            Rectangle()
                .fill(.quaternary)
                .frame(height: 0.5),
            alignment: .bottom
        )
    }
    
    // MARK: - iPad Sidebar (invariato)
    @ViewBuilder
    private func iPadSidebar(width: CGFloat) -> some View {
        VStack(spacing: 0) {
            // Header Sidebar
            VStack(spacing: 16) {
                HStack {
                    Label("Autori", systemImage: "person.2.fill")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                }
                
                // Barra di ricerca iPad con altezza fissa
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    
                    NoAutocorrectTextField(text: $searchText, placeholder: "Cerca autore...")
                        .font(.subheadline)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .frame(height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.regularMaterial)
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.quaternary, lineWidth: 0.5)
                        )
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            // Lista autori per iPad
            if filteredAuthors.isEmpty {
                ContentUnavailableView(
                    "Nessun risultato",
                    systemImage: "magnifyingglass",
                    description: Text("Prova a cercare con un altro termine")
                )
                .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(filteredAuthors.enumerated()), id: \.element) { index, author in
                            iPadAuthorRowView(
                                author: author,
                                poemCount: poemsData.getAuthorCount(author),
                                isLast: index == filteredAuthors.count - 1
                            ) {
                                selectedAuthor = author
                                selectedAuthorItem = AuthorItem(name: author)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.regularMaterial)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.quaternary, lineWidth: 0.5)
                            )
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .frame(width: width)
        .background(.regularMaterial)
    }
    
    // MARK: - iPad Main Content (invariato)
    @ViewBuilder
    private func iPadMainContent(width: CGFloat) -> some View {
        ScrollView {
            LazyVStack(spacing: 40) {
                // Sezione Poesia Casuale iPad
                VStack(spacing: 24) {
                    iPadSectionHeader(
                        title: "Poesia del Momento",
                        systemImage: "quote.bubble.fill",
                        action: refreshRandomPoem,
                        actionIcon: "arrow.clockwise",
                        rotationAngle: rotationAngle
                    )
                    
                    if let poem = randomPoem {
                        iPadFeaturedPoemCard(poem: poem) {
                            selectedPoem = poem
                        }
                    }
                }
                
                // Griglia Poesie per iPad
                VStack(spacing: 24) {
                    iPadSectionHeader(
                        title: "Esplora le Poesie",
                        systemImage: "books.vertical.fill"
                    )
                    
                    let columns = [
                        GridItem(.flexible(), spacing: 20),
                        GridItem(.flexible(), spacing: 20)
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(shuffledPoems.prefix(24)) { poem in
                            iPadPoemGridCard(poem: poem) {
                                selectedPoem = poem
                            }
                        }
                    }
                    
                    if shuffledPoems.count > 24 {
                        Button("Mostra Altre Poesie") {
                            shuffledPoems = poemsData.getShuffledPoems()
                        }
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .padding(.top, 16)
                    }
                }
                
                // Footer iPad
                iPadFooter()
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 32)
        }
        .frame(width: width)
    }
    
    // MARK: - iPhone Layout (esistente)
    @ViewBuilder
    private var iPhoneLayout: some View {
        ScrollView {
            LazyVStack(spacing: 32) {
                // Debug indicator (rimuovi dopo il test)
                if !isDataLoaded {
                    HStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Caricamento dati...")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.regularMaterial)
                            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.quaternary, lineWidth: 0.5)
                            )
                    )
                    .padding(.horizontal, 16)
                }
                
                // Sezione Poesia Casuale
                VStack(spacing: 20) {
                    SectionHeaderView(
                        title: "Poesia casuale",
                        systemImage: "quote.bubble",
                        action: refreshRandomPoem,
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
                    
                    // Barra di ricerca
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.secondary)
                            
                            NoAutocorrectTextField(text: $searchText, placeholder: "Cerca autore...")
                            
                            if !searchText.isEmpty {
                                Button(action: { searchText = "" }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.regularMaterial)
                                .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 1)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.quaternary, lineWidth: 0.5)
                                )
                        )
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
                                    selectedAuthorItem = AuthorItem(name: author)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.regularMaterial)
                                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.quaternary, lineWidth: 0.5)
                                )
                        )
                        .padding(.horizontal, 16)
                    }
                }
                
                // Footer
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
    }
    
    // MARK: - iPad Components (invariati)
    
    @ViewBuilder
    private func iPadSectionHeader(
        title: String,
        systemImage: String,
        action: (() -> Void)? = nil,
        actionIcon: String? = nil,
        rotationAngle: Double = 0
    ) -> some View {
        HStack {
            Label(title, systemImage: systemImage)
                .font(.title)
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
    }
    
    @ViewBuilder
    private func iPadFeaturedPoemCard(poem: Poem, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 20) {
                if !poem.title.isEmpty {
                    Text(poem.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                Text(poem.poem)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(8)
                    .lineLimit(6)
                
                HStack {
                    Text("— \(poem.author)")
                        .font(.headline)
                        .foregroundStyle(.tertiary)
                        .fontWeight(.medium)
                        .italic()
                    
                    Spacer()
                    
                    Label("Leggi tutto", systemImage: "arrow.up.right")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.blue)
                        .font(.title3)
                }
            }
            .padding(32)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.regularMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.quaternary, lineWidth: 0.5)
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func iPadPoemGridCard(poem: Poem, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                if !poem.title.isEmpty {
                    Text(poem.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                
                Text(poem.poem)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .lineLimit(4)
                
                Spacer()
                
                HStack {
                    Text("— \(poem.author)")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                        .fontWeight(.medium)
                        .italic()
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right")
                        .foregroundStyle(.blue)
                        .font(.caption)
                }
            }
            .padding(20)
            .frame(height: 180)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.regularMaterial)
                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.quaternary, lineWidth: 0.5)
                    )
            )
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private func iPadAuthorRowView(
        author: String,
        poemCount: Int,
        isLast: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                AuthorAvatarView(author: author, size: 50)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(author)
                        .foregroundStyle(.primary)
                        .font(.headline)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(poemCount) \(poemCount == 1 ? "poesia" : "poesie")")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.tertiary)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(poemCount == 0)
        .opacity(poemCount == 0 ? 0.6 : 1.0)
        
        if !isLast {
            Divider()
                .padding(.leading, 86)
        }
    }
    
    @ViewBuilder
    private func iPadFooter() -> some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.fill")
                .foregroundStyle(.red)
                .font(.title)
            
            Text("Creato da F.C. per Chiara C.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            Text("\"Per chi crede che le parole possano cambiare il mondo\"")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .italic()
                .multilineTextAlignment(.center)
        }
        .padding(.top, 40)
        .padding(.bottom, 60)
    }
    
    // MARK: - Helper Views
    
    @ViewBuilder
    private func fallbackAuthorView(authorName: String) -> some View {
        NavigationStack {
            ContentUnavailableView(
                "Nessuna poesia trovata",
                systemImage: "doc.text",
                description: Text("Non sono state trovate poesie per \(authorName)")
            )
            .navigationTitle(authorName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Chiudi") {
                        selectedAuthorItem = nil
                    }
                    .foregroundStyle(.blue)
                    .fontWeight(.medium)
                }
            }
        }
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Helper Functions
    
    private func setupInitialData() {
        isDataLoaded = true
        randomPoem = poemsData.getRandomPoem()
        shuffledPoems = poemsData.getShuffledPoems()
        
        let totalPoems = poemsData.poems.count
        let totalAuthors = poemsData.getUniqueAuthors().count
        
        print("📊 Setup iniziale:")
        print("   - Poesie totali: \(totalPoems)")
        print("   - Autori totali: \(totalAuthors)")
        print("   - Poesia casuale: \(randomPoem?.title ?? "Nessuna")")
        print("   - Poesie shuffle: \(shuffledPoems.count)")
        print("✅ Dati caricati con successo!")
    }
    
    private func refreshRandomPoem() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            randomPoem = poemsData.getRandomPoem()
        }
        
        withAnimation(.easeInOut(duration: 0.8)) {
            rotationAngle += 360
        }
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

// MARK: - Existing components for iPhone compatibility

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
        .disabled(poemCount == 0)
        .opacity(poemCount == 0 ? 0.6 : 1.0)
        
        if !isLast {
            Divider()
                .padding(.leading, 68)
        }
    }
}

#Preview("iPad Layout") {
    ContentView()
        .previewDevice("iPad Pro (12.9-inch) (6th generation)")
        .previewDisplayName("iPad Pro")
}

#Preview("iPhone Layout") {
    ContentView()
        .previewDevice("iPhone 15 Pro")
        .previewDisplayName("iPhone")
}
