import SwiftUI

@main
struct Pillole_Poetiche: App {
    @StateObject private var onboardingManager = OnboardingManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // App principale
                ContentView()
                    .opacity((!onboardingManager.showSplashScreen && !onboardingManager.isFirstLaunch) ? 1 : 0)
                
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
        }
    }
}
