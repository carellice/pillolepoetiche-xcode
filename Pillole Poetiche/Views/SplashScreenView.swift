import SwiftUI

struct SplashScreenView: View {
    @State private var isAnimating = false
    @State private var opacity = 0.0
    @State private var scale = 0.8
    @State private var rotationAngle = 0.0
    @State private var particlesVisible = false
    
    let onComplete: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient animato
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.8),
                        Color.purple.opacity(0.6),
                        Color.pink.opacity(0.4)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .hueRotation(.degrees(isAnimating ? 30 : 0))
                .animation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true), value: isAnimating)
                
                // Particelle di sfondo
                if particlesVisible {
                    ForEach(0..<20, id: \.self) { index in
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: CGFloat.random(in: 4...12))
                            .position(
                                x: CGFloat.random(in: 0...geometry.size.width),
                                y: CGFloat.random(in: 0...geometry.size.height)
                            )
                            .animation(
                                .easeInOut(duration: Double.random(in: 2...4))
                                .repeatForever(autoreverses: true)
                                .delay(Double.random(in: 0...2)),
                                value: isAnimating
                            )
                            .scaleEffect(isAnimating ? 1.5 : 0.5)
                    }
                }
                
                // Contenuto principale
                VStack(spacing: 40) {
                    Spacer()
                    
                    // Logo/Icona principale
                    VStack(spacing: 20) {
                        ZStack {
                            // Cerchio di sfondo con glow
                            Circle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 140, height: 140)
                                .scaleEffect(isAnimating ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                            
                            // Icona principale
                            Image(systemName: "quote.bubble.fill")
                                .font(.system(size: 60))
                                .foregroundStyle(.white)
                                .rotationEffect(.degrees(rotationAngle))
                                .scaleEffect(scale)
                                .shadow(color: .white.opacity(0.3), radius: 10)
                        }
                        
                        // Titolo app
                        Text("Pillole Poetiche")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .opacity(opacity)
                            .scaleEffect(scale)
                    }
                    
                    Spacer()
                    
                    // Indicatore di caricamento
                    VStack(spacing: 16) {
                        // Loading dots animati
                        HStack(spacing: 8) {
                            ForEach(0..<3) { index in
                                Circle()
                                    .fill(.white.opacity(0.8))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(isAnimating ? 1.2 : 0.8)
                                    .animation(
                                        .easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.2),
                                        value: isAnimating
                                    )
                            }
                        }
                        
                        Text("Caricamento delle poesie...")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                            .opacity(opacity)
                    }
                    .padding(.bottom, 80)
                }
            }
        }
        .onAppear {
            startAnimations()
            
            // Completa lo splash screen dopo 3 secondi
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                onComplete()
            }
        }
    }
    
    private func startAnimations() {
        // Animazione iniziale dell'icona
        withAnimation(.spring(response: 1.0, dampingFraction: 0.6)) {
            scale = 1.0
            opacity = 1.0
        }
        
        // Rotazione continua dell'icona
        withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // Attiva le altre animazioni
        withAnimation(.easeInOut(duration: 0.5)) {
            isAnimating = true
        }
        
        // Mostra le particelle dopo un breve delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 1.0)) {
                particlesVisible = true
            }
        }
    }
}

#Preview {
    SplashScreenView {
        print("Splash screen completed")
    }
}
