import SwiftUI

@main
struct Pillole_Poetiche: App {
    @StateObject private var onboardingManager = OnboardingManager()
    @StateObject private var deepLinkManager = DeepLinkingManager()
    
    init() {
        // Forza localizzazione italiana per il menu di condivisione
        UserDefaults.standard.set(["it"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // App principale
                ContentView()
                    .opacity((!onboardingManager.showSplashScreen && !onboardingManager.isFirstLaunch) ? 1 : 0)
                    .environmentObject(deepLinkManager)
                
                // Onboarding (solo al primo avvio)
                if onboardingManager.isFirstLaunch && !onboardingManager.showSplashScreen {
                    OnboardingView {
                        onboardingManager.completeOnboarding()
                    }
                    .transition(.opacity)
                    .zIndex(2)
                }
                
                // Splash Screen (sempre all'avvio)
                if onboardingManager.showSplashScreen {
                    SplashScreenView {
                        onboardingManager.completeSplashScreen()
                    }
                    .transition(.opacity)
                    .zIndex(3)
                }
            }
            .animation(.easeInOut(duration: 1.2), value: onboardingManager.showSplashScreen)
            .animation(.easeInOut(duration: 1.0), value: onboardingManager.isFirstLaunch)
            // Gestione deep link dai widget
            .onOpenURL { url in
                // Attendi che l'app sia completamente caricata
                if !onboardingManager.showSplashScreen && !onboardingManager.isFirstLaunch {
                    deepLinkManager.handle(url: url)
                } else {
                    // Se l'app non è ancora caricata, gestisci il link dopo il caricamento
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        deepLinkManager.handle(url: url)
                    }
                }
            }
            // Sheet per mostrare poesia specifica dal widget a SCHERMO INTERO
            .fullScreenCover(isPresented: $deepLinkManager.shouldShowSpecificPoem) {
                if let poemID = deepLinkManager.selectedPoemID {
                    let poemsData = PoemsData()
                    if let poem = poemsData.findPoem(by: poemID) {
                        FullScreenPoemView(poem: poem)
                            .onDisappear {
                                deepLinkManager.resetState()
                            }
                    } else {
                        // Fallback migliorato con debug info
                        VStack(spacing: 20) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundStyle(.orange)
                            
                            Text("Poesia non trovata")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("ID cercato: \(poemID.uuidString.prefix(8))...")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Button("Chiudi") {
                                deepLinkManager.resetState()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.black)
                        .foregroundStyle(.white)
                    }
                }
            }
            // Imposta ambiente per supportare italiano
            .environment(\.locale, Locale(identifier: "it_IT"))
        }
    }
}
