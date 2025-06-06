import SwiftUI
import UIKit

// MARK: - Generatore di Immagini Semplificato
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
            .font: UIFont.systemFont(ofSize: 64, weight: .bold), // Aumentato da 48 a 64
            .foregroundColor: UIColor.white,
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                style.lineSpacing = 10 // Aumentato lo spazio tra le righe
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
                style.lineSpacing = fontSize * 0.35 // Spazio proporzionale alla dimensione del font
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
            .font: UIFont.systemFont(ofSize: 42, weight: .medium), // Aumentato da 32 a 42
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
    
    private static func drawAppName(at center: CGPoint) {
        // Nome dell'app più grande
        let appName = "Pillole Poetiche"
        let appAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 38, weight: .semibold), // Aumentato da 28 a 38
            .foregroundColor: UIColor.white.withAlphaComponent(0.8),
            .paragraphStyle: {
                let style = NSMutableParagraphStyle()
                style.alignment = .center
                return style
            }()
        ]
        
        let appSize = appName.size(withAttributes: appAttributes)
        let appRect = CGRect(
            x: center.x - appSize.width/2,
            y: center.y - appSize.height/2,
            width: appSize.width,
            height: appSize.height
        )
        
        appName.draw(in: appRect, withAttributes: appAttributes)
    }
    
    // MARK: - Funzione principale (ora le helper sono già definite)
    
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
            let startY = currentY
            
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
            
            // Nome app in basso (posizione fissa)
            drawAppName(at: CGPoint(x: size.width / 2, y: size.height - 100))
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
