import SwiftUI
import UIKit

// MARK: - TextField personalizzato senza autocorrettore (versione ULTRA aggressiva)
struct NoAutocorrectTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        
        // Configurazione di base
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        
        // CONFIGURAZIONE ULTRA AGGRESSIVA PER DISABILITARE TUTTO
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.smartQuotesType = .no
        textField.smartDashesType = .no
        textField.smartInsertDeleteType = .no
        textField.keyboardType = .asciiCapable
        
        // DISABILITA LA BARRA DEI SUGGERIMENTI (iOS 9+)
        if #available(iOS 9.0, *) {
            textField.inputAssistantItem.leadingBarButtonGroups = []
            textField.inputAssistantItem.trailingBarButtonGroups = []
        }
        
        // Font e aspetto per iOS nativo
        textField.font = UIFont.systemFont(ofSize: 16)
        if #available(iOS 13.0, *) {
            textField.textColor = UIColor.label
        } else {
            textField.textColor = UIColor.black
        }
        
        // Delegate per aggiornare il binding
        textField.delegate = context.coordinator
        
        // Target per il cambio di testo
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textFieldDidChange(_:)),
            for: .editingChanged
        )
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        // Aggiorna il testo solo se diverso per evitare loop
        if uiView.text != text {
            uiView.text = text
        }
        
        // FORZA LA RICONFIGURAZIONE (per iOS 18)
        uiView.autocorrectionType = .no
        uiView.spellCheckingType = .no
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator per gestire i delegate
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: NoAutocorrectTextField
        
        init(_ parent: NoAutocorrectTextField) {
            self.parent = parent
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            // Aggiorna il binding quando l'utente digita
            parent.text = textField.text ?? ""
        }
        
        // OVERRIDE per forzare la disabilitazione dell'autocorrettore
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Forza la riconfigurazione ad ogni carattere digitato
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
            return true
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            // Forza la configurazione quando inizia l'editing
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
            textField.smartQuotesType = .no
            textField.smartDashesType = .no
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}
