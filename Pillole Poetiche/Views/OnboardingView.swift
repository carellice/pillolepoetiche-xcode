import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isAnimating = false
    @State private var showButton = false
    
    let onComplete: () -> Void
    
    private let pages = [
        OnboardingPage(
            icon: "quote.bubble.fill",
            title: "Benvenuto in\nPillole Poetiche",
            subtitle: "Scopri le più belle citazioni e poesie di autori famosi",
            color: .blue,
            description: "Una collezione curata di frasi che toccano l'anima"
        ),
        OnboardingPage(
            icon: "heart.fill",
            title: "Emozioni\nin Versi",
            subtitle: "Ogni poesia è stata scelta per trasmettere emozioni profonde",
            color: .pink,
            description: "Lasciati ispirare dalle parole dei grandi poeti"
        ),
        OnboardingPage(
            icon: "person.2.fill",
            title: "Autori\nLeggendari",
            subtitle: "Da Leopardi a Bukowski, da Einstein a Neruda",
            color: .purple,
            description: "Esplora le opere di grandi pensatori e poeti"
        ),
        OnboardingPage(
            icon: "doc.on.doc.fill",
            title: "Condividi\nl'Ispirazione",
            subtitle: "Copia e condividi le tue poesie preferite",
            color: .green,
            description: "Porta la bellezza della poesia nella tua vita quotidiana"
        )
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background animato
                LinearGradient(
                    colors: [
                        pages[currentPage].color.opacity(0.3),
                        pages[currentPage].color.opacity(0.1),
                        Color(UIColor.systemBackground)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.8), value: currentPage)
                
                VStack(spacing: 0) {
                    // Contenuto principale
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageView(
                                page: pages[index],
                                isActive: currentPage == index
                            )
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: geometry.size.height * 0.75)
                    
                    // Controlli inferiori
                    VStack(spacing: 30) {
                        // Indicatori di pagina personalizzati
                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Capsule()
                                    .fill(currentPage == index ? pages[currentPage].color : Color.gray.opacity(0.3))
                                    .frame(
                                        width: currentPage == index ? 24 : 8,
                                        height: 8
                                    )
                                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: currentPage)
                            }
                        }
                        
                        // Pulsanti di navigazione
                        HStack {
                            // Pulsante Skip (solo se non siamo all'ultima pagina)
                            if currentPage < pages.count - 1 {
                                Button("Salta") {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        currentPage = pages.count - 1
                                    }
                                }
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            } else {
                                Spacer()
                            }
                            
                            Spacer()
                            
                            // Pulsante principale
                            Button(action: nextPage) {
                                HStack(spacing: 8) {
                                    Text(currentPage == pages.count - 1 ? "Inizia" : "Avanti")
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: currentPage == pages.count - 1 ? "checkmark" : "arrow.right")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                .foregroundStyle(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule()
                                        .fill(pages[currentPage].color.gradient)
                                        .shadow(color: pages[currentPage].color.opacity(0.3), radius: 8, y: 4)
                                )
                            }
                            .scaleEffect(showButton ? 1.0 : 0.8)
                            .opacity(showButton ? 1.0 : 0.0)
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showButton)
                        }
                        .padding(.horizontal, 32)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showButton = true
                }
            }
        }
    }
    
    private func nextPage() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
        
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.5)) {
                currentPage += 1
            }
        } else {
            // Completa l'onboarding
            onComplete()
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    let isActive: Bool
    
    @State private var iconScale = 0.5
    @State private var textOpacity = 0.0
    @State private var iconRotation = 0.0
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icona principale con animazioni
            ZStack {
                // Cerchio di sfondo animato
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 180, height: 180)
                    .scaleEffect(isActive ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isActive)
                
                // Cerchio intermedio
                Circle()
                    .stroke(page.color.opacity(0.2), lineWidth: 2)
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(iconRotation))
                
                // Icona centrale
                Image(systemName: page.icon)
                    .font(.system(size: 60, weight: .medium))
                    .foregroundStyle(page.color.gradient)
                    .scaleEffect(iconScale)
                    .shadow(color: page.color.opacity(0.3), radius: 10)
            }
            
            // Testo
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                
                Text(page.subtitle)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                    .padding(.horizontal, 32)
                
                Text(page.description)
                    .font(.body)
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                    .padding(.horizontal, 40)
                    .padding(.top, 8)
            }
            
            Spacer()
        }
        .onChange(of: isActive) { oldValue, newValue in
            if newValue {
                startAnimations()
            }
        }
        .onAppear {
            if isActive {
                startAnimations()
            }
        }
    }
    
    private func startAnimations() {
        // Reset delle animazioni
        iconScale = 0.5
        textOpacity = 0.0
        iconRotation = 0.0
        
        // Animazione dell'icona
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.1)) {
            iconScale = 1.0
        }
        
        // Animazione del testo
        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            textOpacity = 1.0
        }
        
        // Rotazione continua del cerchio
        withAnimation(.linear(duration: 20.0).repeatForever(autoreverses: false)) {
            iconRotation = 360
        }
    }
}

#Preview("Onboarding") {
    OnboardingView {
        print("Onboarding completed")
    }
}

#Preview("Single Page") {
    OnboardingPageView(
        page: OnboardingPage(
            icon: "quote.bubble.fill",
            title: "Benvenuto in\nPillole Poetiche",
            subtitle: "Scopri le più belle citazioni e poesie di autori famosi",
            color: .blue,
            description: "Una collezione curata di frasi che toccano l'anima"
        ),
        isActive: true
    )
}
