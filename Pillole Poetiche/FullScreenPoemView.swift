import SwiftUI

struct FullScreenPoemView: View {
    let poem: Poem
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var showingShareSheet = false
    
    // Formato personalizzato per la condivisione
    private var shareText: String {
        if poem.title.isEmpty {
            return "\"\(poem.poem)\"\n— \(poem.author)\n\nhttps://www.flavioceccarelli.org"
        } else {
            return "\"\(poem.title)\"\n\(poem.poem)\n— \(poem.author)\n\nhttps://www.flavioceccarelli.org"
        }
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    // Header dal widget
                    VStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.8))
                        
                        Text("Dal Widget")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.7))
                            .italic()
                    }
                    .padding(.top, 20)
                    
                    // Contenuto principale
                    VStack(spacing: 24) {
                        // Titolo se presente
                        if !poem.title.isEmpty {
                            Text(poem.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .shadow(radius: 2)
                        }
                        
                        // Testo completo
                        Text(poem.poem)
                            .font(.title2)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .shadow(radius: 1)
                        
                        // Separatore elegante
                        HStack {
                            Rectangle()
                                .fill(.white.opacity(0.3))
                                .frame(width: 50, height: 1)
                            
                            Circle()
                                .fill(.white.opacity(0.5))
                                .frame(width: 6, height: 6)
                            
                            Rectangle()
                                .fill(.white.opacity(0.3))
                                .frame(width: 50, height: 1)
                        }
                        
                        // Autore
                        Text(poem.author)
                            .font(.title)
                            .foregroundStyle(.white.opacity(0.9))
                            .italic()
                            .fontWeight(.medium)
                            .shadow(radius: 1)
                        
                        // Pulsante Condividi
                        Button {
                            showingShareSheet = true
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                                
                                Text("Condividi Poesia")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 25))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        .shadow(radius: 4)
                        .padding(.top, 16)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
            
            // Controlli in alto
            VStack {
                HStack {
                    // ❌ RIMOSSO: Pulsante condividi in alto a sinistra
                    
                    Spacer()
                    
                    // Pulsante chiusura in alto a destra
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.8))
                            .background(.black.opacity(0.3), in: Circle())
                    }
                    .padding(.trailing, 20)
                }
                .padding(.top, 20)
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: [shareText]) // Usa il formato personalizzato
        }
    }
    
    private var backgroundColors: [Color] {
        if colorScheme == .dark {
            return [
                Color.blue.opacity(0.6),
                Color.purple.opacity(0.7),
                Color.pink.opacity(0.5),
                Color.black.opacity(0.8)
            ]
        } else {
            return [
                Color.blue.opacity(0.4),
                Color.purple.opacity(0.5),
                Color.pink.opacity(0.3),
                Color.white.opacity(0.9)
            ]
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Preview
#Preview {
    FullScreenPoemView(poem: Poem.placeholder)
}
