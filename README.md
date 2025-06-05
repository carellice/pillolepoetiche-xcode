<p align="center">
  <a href="https://www.flavioceccarelli.org" target="_blank">
    <img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83" alt="Download on the App Store" style="height: 60px;">
  </a>
</p>

# 📖 Pillole Poetiche

**L'app definitiva per scoprire e condividere la bellezza della poesia**

Pillole Poetiche è un'applicazione iOS nativa sviluppata in SwiftUI che ti accompagna in un viaggio attraverso le più belle citazioni e poesie di autori celebri. Scopri, leggi e condividi frasi che toccano l'anima, con un design elegante e funzionalità moderne.

---

## 📸 Screenshot

<p align="center">
  <img src="https://github.com/carellice/pillolepoetiche-xcode/blob/main/screenshots/App%20Store/iPhone/English%20%5Ben%5D%20%7C%20iPhone%20-%206.9%22%20Display%20-%201%20%7C%202025-06-05_10-25-47.jpeg?raw=true" alt="Home Screen" width="230">
  <img src="https://github.com/carellice/pillolepoetiche-xcode/blob/main/screenshots/App%20Store/iPhone/English%20%5Ben%5D%20%7C%20iPhone%20-%206.9%22%20Display%20-%202%20%7C%202025-06-05_10-25-47.jpeg?raw=true" alt="Lista Autori" width="230">
  <img src="https://github.com/carellice/pillolepoetiche-xcode/blob/main/screenshots/App%20Store/iPhone/English%20%5Ben%5D%20%7C%20iPhone%20-%206.9%22%20Display%20-%203%20%7C%202025-06-05_10-25-47.jpeg?raw=true" alt="Carousel Poesie" width="230">
</p>

---

## ✨ Caratteristiche Principali

### 📚 Ricca Collezione Poetica
- **Database completo** con centinaia di citazioni e poesie
- **Autori celebri**: Da Leopardi a Bukowski, da Einstein a Neruda
- **Categorizzazione intelligente** per autore e stile
- **Contenuti curati** per qualità e impatto emotivo

### 🎨 Interfaccia Moderna ed Elegante
- **Design iOS nativo** seguendo le Human Interface Guidelines
- **Carousel interattivo** per scorrere le poesie con animazioni fluide
- **Card adattive** con altezza fissa e troncamento intelligente
- **Avatar personalizzati** per ogni autore con fallback alle iniziali

### 🔍 Ricerca e Navigazione Avanzata
- **Barra di ricerca nativa** per trovare autori rapidamente
- **Lista autori** con conteggio poesie e design pulito
- **Poesia casuale** con pulsante refresh animato
- **Sezione scorri poesie** con scroll orizzontale ottimizzato

### 📖 Esperienza di Lettura Ottimizzata
- **Vista completa** per leggere poesie intere
- **Troncamento intelligente**: 162 caratteri (con titolo) o 210 caratteri (senza titolo)
- **Condivisione facile** con copia negli appunti
- **Feedback aptico** per interazioni coinvolgenti

### 🎭 Sistema di Onboarding Accattivante
- **Splash screen animata** con effetti particellari
- **Onboarding a 4 schermate** che presenta le funzionalità
- **Animazioni fluide** in stile Apple
- **Gestione primo avvio** automatica

### 🌓 Supporto Modalità Chiara e Scura
- **Contrasto ottimizzato** per entrambe le modalità
- **Shadow e bordi** per separazione visiva netta
- **Materiali iOS** per effetti di profondità
- **Adattamento automatico** al tema di sistema

---

## 🛠 Tecnologie Utilizzate

- **Framework**: SwiftUI nativo per iOS 18+
- **Architettura**: MVVM con ObservableObject per gestione stato
- **Persistenza**: UserDefaults per preferenze utente
- **Animazioni**: SwiftUI native con curve personalizzate
- **Gestione Immagini**: Asset Catalog con sistema di fallback
- **UI/UX**: Material Design iOS con effetti di profondità

## 📋 Requisiti di Sistema

- **iOS**: 18.0 o superiore
- **Xcode**: 15.0 o superiore
- **Swift**: 5.9 o superiore
- **Dispositivi**: iPhone e iPad (Universal)
- **macOS**: 14.0+ per sviluppo

## 🚀 Installazione e Setup

### Clone del Repository
```bash
git clone https://github.com/flaviocecca/pillole-poetiche-xcode.git
cd pillole-poetiche-xcode
```

### Configurazione Xcode
1. Apri `Pillole Poetiche.xcodeproj` in Xcode
2. Seleziona il tuo team di sviluppo in Signing & Capabilities
3. Modifica il Bundle Identifier se necessario
4. Aggiungi le immagini degli autori all'Asset Catalog
5. Compila ed esegui su simulatore o dispositivo

### Aggiungere Immagini Autori
1. Apri `Assets.xcassets` in Xcode
2. Aggiungi immagini con naming convention: `nome_cognome.png`
3. Aggiorna `AuthorImageManager.swift` con nuove mappature
4. Usa `AuthorImageDebugView` per verificare il caricamento

---

## 📁 Struttura del Progetto

```
Pillole Poetiche/
├── 📱 App/
│   ├── Pillole_PoeticheApp.swift   # Entry point con gestione onboarding
│   ├── ContentView.swift           # Vista principale con sezioni
│   ├── SplashScreenView.swift      # Schermata caricamento animata
│   └── OnboardingView.swift        # Introduzione app per primi utenti
├── 🗄️ Models/
│   ├── Poem.swift                  # Modello dati poesia
│   └── PoemsData.swift             # Gestore database poesie
├── 👁️ Views/
│   ├── PoemCardView.swift          # Card poesia con troncamento
│   ├── AuthorDetailView.swift      # Dettaglio autore con poesie
│   ├── AuthorAvatarView.swift      # Avatar autore con immagini
│   └── Components/                 # Componenti riutilizzabili
├── 🎛️ Managers/
│   ├── AuthorImageManager.swift    # Gestione immagini profilo
│   └── OnboardingManager.swift     # Gestione primo avvio
├── 🎨 Extensions/
│   └── Color+Extensions.swift      # Colori e temi personalizzati
├── 📖 Data/
│   └── poems.json                  # Database poesie e citazioni
├── 🖼️ Assets.xcassets/             # Immagini e asset
│   ├── albert_einstein.png
│   ├── charles_bukowski.png
│   └── [altre immagini autori...]
└── 📱 Debug/
    └── AuthorImageDebugView.swift  # Tool debug per immagini
```

## 🎯 Funzionalità Principali

### Sistema di Poesie
- **Caricamento efficiente** da JSON con parsing robusto
- **Poesia casuale** con refresh animato
- **Carousel orizzontale** con paginazione fluida
- **Vista completa** per lettura immersiva

### Gestione Autori
- **Database completo** con oltre 50 autori famosi
- **Immagini profilo** con sistema di fallback intelligente
- **Conteggio poesie** per ogni autore
- **Ricerca istantanea** con filtri live

### Esperienza Utente
- **Onboarding coinvolgente** solo al primo avvio
- **Splash screen** con animazioni particellari
- **Feedback aptico** per tutte le interazioni
- **Condivisione seamless** con formattazione automatica

## 🎨 Design System

### Colori e Temi
- **Palette adattiva** per light/dark mode
- **Accent colors** che seguono il sistema
- **Gradienti dinamici** per elementi interattivi
- **Contrasto ottimizzato** per accessibilità

### Tipografia
- **Font di sistema** con sizing dinamico
- **Gerarchia chiara** titoli, sottotitoli, corpo
- **Spaziatura ottimizzata** per leggibilità
- **Support per Dynamic Type**

### Animazioni
- **Spring animations** per feedback naturale
- **Ease curves** in stile Apple
- **Micro-interazioni** per coinvolgimento
- **Transizioni fluide** tra viste

## 🎯 Roadmap

### Versione 1.1
- [ ] Funzione "Preferiti" per salvare poesie
- [ ] Condivisione diretta sui social media
- [ ] Widget per Home Screen con poesia del giorno
- [ ] Modalità lettura notturna avanzata

### Versione 1.2
- [ ] Sincronizzazione iCloud per preferiti
- [ ] Audio narrazione per poesie selezionate
- [ ] Temi personalizzabili e font alternativi
- [ ] Integrazione con Shortcuts di iOS

### Versione 2.0
- [ ] Sezione commenti e discussioni community
- [ ] Sistema di raccomandazioni basato su AI
- [ ] Poesie generate da utenti (con moderazione)
- [ ] Modalità studio con analisi letteraria

## 🤝 Contribuire

I contributi sono benvenuti! Per contribuire:

1. **Fork** il repository
2. **Crea** un branch per la tua feature (`git checkout -b feature/NewPoem`)
3. **Commit** le tue modifiche (`git commit -m 'Add new poem collection'`)
4. **Push** al branch (`git push origin feature/NewPoem`)
5. **Apri** una Pull Request

### Linee Guida per i Contributi
- Segui le convenzioni SwiftUI esistenti nel progetto
- Mantieni la coerenza del design system
- Testa su dispositivi reali per performance
- Aggiungi commenti per codice complesso
- Documenta le nuove funzionalità nel README

### Come Contribuire Contenuti
- **Nuove poesie**: Aggiungi al file `poems.json` con formato corretto
- **Nuovi autori**: Includi biografia breve e immagine profilo
- **Traduzioni**: Crea versioni in altre lingue
- **Correzioni**: Segnala errori di testo o attribuzioni

## 🐛 Bug Report e Feature Request

Per segnalare bug o richiedere nuove funzionalità, apri una [issue](https://github.com/flaviocecca/pillole-poetiche-xcode/issues) con:

**Per i Bug:**
- Descrizione dettagliata del problema
- Passi per riprodurre il bug
- Screenshots/video se applicabili
- Versione iOS e modello dispositivo
- Log della console se disponibili

**Per le Feature:**
- Descrizione chiara della funzionalità
- Casi d'uso specifici per lettori di poesia
- Mockup dell'interfaccia se disponibili
- Riferimenti ad app simili per ispirazione

## 📖 Note sui Contenuti

Le poesie e citazioni incluse in questo progetto sono:
- Di dominio pubblico o con attribuzione corretta
- Verificate per accuratezza e autenticità
- Selezionate per valore letterario e impatto emotivo
- Rispettose dei diritti d'autore quando applicabili

Per aggiungere nuovi contenuti, assicurati che siano:
- Liberi da copyright o con licenza appropriata
- Correttamente attribuiti all'autore originale
- Formattati secondo lo schema JSON esistente
- Di qualità letteraria adeguata al target dell'app

## 📄 Licenza

Questo progetto è rilasciato sotto licenza MIT. Vedi il file [LICENSE](LICENSE) per i dettagli.

---

## 👨‍💻 Autore

**Flavio Ceccarelli** - [@flaviocecca](https://github.com/flaviocecca)

- 🌐 Website: [flavioceccarelli.org](https://www.flavioceccarelli.org)
- 📧 Email: [Contatta tramite GitHub](https://github.com/flaviocecca)

---

**📖 Ti piace Pillole Poetiche?** Lascia una stella al repository e condividilo con chi ama la poesia!

**✨ Dedicato a Chiara C.** - *"Per chi crede che le parole possano cambiare il mondo, una poesia alla volta."*

---

### 🎭 Alcuni Autori Inclusi

> *"Scopri le voci di grandi pensatori e poeti che hanno segnato la storia"*

**Classici Italiani:** Leopardi, Pirandello, Montale, Pavese, Merini  
**Filosofi Antichi:** Seneca, Marco Aurelio, Confucio, Platone  
**Letteratura Internazionale:** Shakespeare, Dickens, Proust, Kafka  
**Poeti Moderni:** Bukowski, Neruda, Cohen, Angelou  
**Pensatori Contemporanei:** Einstein, Hawking, Jung, Fromm  

*E molti altri in una collezione in continua crescita...*
