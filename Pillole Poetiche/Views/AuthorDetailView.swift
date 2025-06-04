import SwiftUI

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

#Preview("Light Mode") {
    AuthorDetailView(
        author: "Charles Bukowski",
        poems: [
            Poem(title: "Test 1", poem: "Prima poesia di test lunga per vedere come viene visualizzata nel nuovo design iOS nativo", author: "Charles Bukowski"),
            Poem(title: "", poem: "Seconda poesia senza titolo", author: "Charles Bukowski"),
            Poem(title: "Poesia con titolo lungo", poem: "Terza poesia per testare il layout", author: "Charles Bukowski")
        ]
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    AuthorDetailView(
        author: "Charles Bukowski",
        poems: [
            Poem(title: "Test 1", poem: "Prima poesia di test lunga per vedere come viene visualizzata nel nuovo design iOS nativo", author: "Charles Bukowski"),
            Poem(title: "", poem: "Seconda poesia senza titolo", author: "Charles Bukowski"),
            Poem(title: "Poesia con titolo lungo", poem: "Terza poesia per testare il layout", author: "Charles Bukowski")
        ]
    )
    .preferredColorScheme(.dark)
}
