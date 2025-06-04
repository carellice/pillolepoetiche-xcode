import Foundation
import SwiftUI

class OnboardingManager: ObservableObject {
    @Published var isFirstLaunch: Bool
    @Published var showSplashScreen: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let firstLaunchKey = "isFirstLaunch"
    
    init() {
        // Controlla se è il primo avvio
        self.isFirstLaunch = !userDefaults.bool(forKey: firstLaunchKey)
    }
    
    func completeOnboarding() {
        userDefaults.set(true, forKey: firstLaunchKey)
        withAnimation(.easeInOut(duration: 1.0)) {
            isFirstLaunch = false
        }
    }
    
    func completeSplashScreen() {
        withAnimation(.easeInOut(duration: 1.2)) {
            showSplashScreen = false
        }
    }
    
    // Reset per testing (solo per debug)
    func resetOnboarding() {
        userDefaults.removeObject(forKey: firstLaunchKey)
        isFirstLaunch = true
        showSplashScreen = true
    }
}
