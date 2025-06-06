import SwiftUI
import UIKit

// MARK: - Generatore di Immagini con Icona App
class PoemImageGenerator {
    
    // MARK: - Helper Functions (definite per prime)
    
    private static func createSimpleGradient() -> CGGradient {
        let colors = [
            UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0).cgColor,  // Blu
            UIColor(red: 0.5, green: 0.2, blue: 0.7, alpha: 1.0).cgColor   // Viola
        ]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        return CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0.0, 1.0])!
    }
    
    // Calcola la dimensione del font ottimale per far stare il testo nello spazio disponibile
    private static func calculateOptimalFontSize(text: String, maxWidth: CGFloat, maxHeight: CGFloat, minFontSize: CGFloat, maxFontSize: CGFloat) -> CGFloat {
        var fontSize = maxFontSize
        
        while fontSize >= minFontSize {
            let height = calculateTextHeight(text, font: UIFont.systemFont(ofSize: fontSize, weight: .regular), width: maxWidth, lineSpacing: fontSize * 0.35)
            
            if height <= maxHeight {
                return fontSize
            }
            
            fontSize -= 2 // Riduci di 2 punti alla volta
        }
        
        return minFontSize
    }
    
    // Versione migliorata per calcolare l'altezza del testo con line spacing
    private static func calculateTextHeight(_ text: String, font: UIFont, width: CGFloat, lineSpacing: CGFloat = 0) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                style.lineSpacing = lineSpacing
                return style
            }()
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let rect = attributedText.boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        return rect.height
    }
    
    private static func drawTitle(_ title: String, x: CGFloat, y: CGFloat, width: CGFloat) -> CGFloat {
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 64, weight: .bold),
            .foregroundColor: UIColor.white,
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                style.lineSpacing = 10
                return style
            }()
        ]
        
        let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
        let titleRect = attributedTitle.boundingRect(
            with: CGSize(width: width, height: 300),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        let drawRect = CGRect(x: x, y: y, width: width, height: titleRect.height)
        attributedTitle.draw(in: drawRect)
        
        return titleRect.height
    }
    
    private static func drawPoemText(_ text: String, x: CGFloat, y: CGFloat, width: CGFloat, fontSize: CGFloat) -> CGFloat {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: .regular),
            .foregroundColor: UIColor.white,
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                style.lineSpacing = fontSize * 0.35
                return style
            }()
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: textAttributes)
        let textRect = attributedText.boundingRect(
            with: CGSize(width: width, height: 800),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        let drawRect = CGRect(x: x, y: y, width: width, height: textRect.height)
        attributedText.draw(in: drawRect)
        
        return textRect.height
    }
    
    private static func drawAuthor(_ author: String, x: CGFloat, y: CGFloat, width: CGFloat) -> CGFloat {
        let authorText = "— \(author)"
        let authorAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 42, weight: .medium),
            .foregroundColor: UIColor.white.withAlphaComponent(0.9),
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                return style
            }()
        ]
        
        let attributedAuthor = NSAttributedString(string: authorText, attributes: authorAttributes)
        let authorRect = attributedAuthor.boundingRect(
            with: CGSize(width: width, height: 100),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        let drawRect = CGRect(x: x, y: y, width: width, height: authorRect.height)
        attributedAuthor.draw(in: drawRect)
        
        return authorRect.height
    }
    
    // NUOVO: Funzione per disegnare l'icona SF Symbol bianca (con correzione orientamento)
    private static func drawAppIcon(in context: CGContext, at center: CGPoint, size: CGFloat) {
        // Configura il sistema SF Symbols
        let config = UIImage.SymbolConfiguration(pointSize: size, weight: .semibold)
        
        // Crea l'icona quote.bubble.fill
        if let iconImage = UIImage(systemName: "quote.bubble.fill", withConfiguration: config) {
            // Salva il contesto attuale
            context.saveGState()
            
            // CORREZIONE: Inverti il sistema di coordinate per Core Graphics
            let iconRect = CGRect(
                x: center.x - iconImage.size.width / 2,
                y: center.y - iconImage.size.height / 2,
                width: iconImage.size.width,
                height: iconImage.size.height
            )
            
            // Trasla e ribalta per correggere l'orientamento
            context.translateBy(x: iconRect.midX, y: iconRect.midY)
            context.scaleBy(x: 1.0, y: -1.0) // Ribalta verticalmente
            context.translateBy(x: -iconRect.width/2, y: -iconRect.height/2)
            
            // Imposta il colore bianco
            context.setFillColor(UIColor.white.withAlphaComponent(0.8).cgColor)
            
            // Disegna l'icona con orientamento corretto
            if let cgImage = iconImage.withRenderingMode(.alwaysTemplate).cgImage {
                let correctedRect = CGRect(x: 0, y: 0, width: iconRect.width, height: iconRect.height)
                context.clip(to: correctedRect, mask: cgImage)
                context.fill(correctedRect)
            }
            
            // Ripristina il contesto
            context.restoreGState()
        }
    }
    
    // MODIFICATA: Funzione per disegnare nome app CON icona
    private static func drawAppNameWithIcon(at center: CGPoint) {
        let appName = "Pillole Poetiche"
        let fontSize: CGFloat = 38
        let iconSize: CGFloat = 32 // Dimensione dell'icona
        let spacing: CGFloat = 12  // Spazio tra icona e testo
        
        let appAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize, weight: .semibold),
            .foregroundColor: UIColor.white.withAlphaComponent(0.8),
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                return style
            }()
        ]
        
        // Calcola la dimensione del testo
        let appSize = appName.size(withAttributes: appAttributes)
        
        // Calcola la larghezza totale (icona + spazio + testo)
        let totalWidth = iconSize + spacing + appSize.width
        
        // Posizione iniziale dell'icona (a sinistra)
        let iconX = center.x - totalWidth / 2
        let iconCenter = CGPoint(x: iconX + iconSize / 2, y: center.y)
        
        // Posizione del testo (a destra dell'icona)
        let textX = iconX + iconSize + spacing
        let textRect = CGRect(
            x: textX,
            y: center.y - appSize.height / 2,
            width: appSize.width,
            height: appSize.height
        )
        
        // Ottieni il contesto grafico corrente
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Disegna l'icona
        drawAppIcon(in: context, at: iconCenter, size: iconSize)
        
        // Disegna il testo
        appName.draw(in: textRect, withAttributes: appAttributes)
    }
    
    // MARK: - Funzione principale (aggiornata)
    
    // Genera un'immagine quadrata semplice e pulita
    static func generateShareableImage(for poem: Poem) -> UIImage? {
        let size = CGSize(width: 1080, height: 1080) // Formato quadrato perfetto per Instagram
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let cgContext = context.cgContext
            
            // Background gradiente semplice
            let gradient = createSimpleGradient()
            cgContext.drawLinearGradient(
                gradient,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: size.width, y: size.height),
                options: []
            )
            
            // Margini
            let margin: CGFloat = 80
            let contentWidth = size.width - (margin * 2)
            
            // Spazio riservato per il nome dell'app in basso
            let appNameSpace: CGFloat = 120
            let availableHeight = size.height - (margin * 2) - appNameSpace
            
            // Calcolo delle altezze per determinare la dimensione del font
            var currentY: CGFloat = margin + 40
            
            // Calcola l'altezza del titolo
            var titleHeight: CGFloat = 0
            if !poem.title.isEmpty {
                titleHeight = calculateTextHeight(
                    poem.title,
                    font: UIFont.systemFont(ofSize: 64, weight: .bold),
                    width: contentWidth,
                    lineSpacing: 10
                ) + 40 // + margine sotto il titolo
            }
            
            // Calcola l'altezza dell'autore
            let authorHeightEstimate = calculateTextHeight(
                "— \(poem.author)",
                font: UIFont.systemFont(ofSize: 42, weight: .medium),
                width: contentWidth,
                lineSpacing: 0
            ) + 30 // + margine sopra l'autore
            
            // Spazio disponibile per il testo della poesia
            let availableForPoem = availableHeight - titleHeight - authorHeightEstimate
            
            // Calcola la dimensione del font ottimale per il testo della poesia
            let poemFontSize = calculateOptimalFontSize(
                text: poem.poem,
                maxWidth: contentWidth,
                maxHeight: availableForPoem,
                minFontSize: 32,
                maxFontSize: 56
            )
            
            // Ora disegna tutto
            
            // Titolo (se presente)
            if !poem.title.isEmpty {
                let actualTitleHeight = drawTitle(poem.title, x: margin, y: currentY, width: contentWidth)
                currentY += actualTitleHeight + 40
            }
            
            // Testo della poesia con font ottimizzato
            let poemHeight = drawPoemText(poem.poem, x: margin, y: currentY, width: contentWidth, fontSize: poemFontSize)
            currentY += poemHeight + 30
            
            // Autore
            let authorHeight = drawAuthor(poem.author, x: margin, y: currentY, width: contentWidth)
            currentY += authorHeight
            
            // Nome app CON ICONA in basso (posizione fissa)
            drawAppNameWithIcon(at: CGPoint(x: size.width / 2, y: size.height - 100))
        }
    }
    
    // Versione asincrona per SwiftUI
    static func generateShareableImageAsync(for poem: Poem) async -> UIImage? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let image = generateShareableImage(for: poem)
                continuation.resume(returning: image)
            }
        }
    }
}
