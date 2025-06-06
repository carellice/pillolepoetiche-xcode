import Foundation

class PoemsData: ObservableObject {
    @Published var poems: [Poem] = []
    
    init() {
        loadPoems()
    }
    
    private func loadPoems() {
        poems = [
            Poem(title: "tutte le parole che vorrei dirti", poem: "Resterai per sempre la persona che mi ha insegnato cos'è l'amore", author: "Olivia S."),
            Poem(title: "tutte le parole che vorrei dirti", poem: "Ti sceglierei ancora, in 100 altre vite, in 100 altri universi, in qualunque tipo di situazione Io sceglierei sempre e solo te", author: "Olivia S."),
            Poem(title: "", poem: "Continua ad illuminare la mia strada, perchè senza la tua luce amore, sono perso.", author: "Anonimo"),
            Poem(title: "ragazza caleidoscopio", poem: "siamo stati un caos meraviglioso due anime imperfette intrecciate alla perfezione", author: "Hanna J. Rose"),
            Poem(title: "TEMPO", poem: "Granelli di cenere sputati dalle fiamme del tempo. Questo siamo, Ogni nostra impresa, ogni nostro fallimento, svanisce tra i tic tac degli orologi", author: "Michele Vitale"),
            Poem(title: "CHE RAZZA DI GIOCO È...", poem: "Vorrei comprendere il gioco del vivere. Quali son le regole? E perchè mai a vincere è sempre chi bara? Sono stanco di perdere, insegnatemi a giocare!", author: "Michele Vitale"),
            Poem(title: "ABISSO", poem: "Pervade solo me il vuoto? Mi sembran ormai tutti uguali, con nessuno a voler segnare la storia. Lentamente sprofondiamo in quel abisso di mediocrità che si è soliti chiamare noia; la dipartita dell'uomo. Goda chi si sente diverso in un mondo di specchi.", author: "Michele Vitale"),
            Poem(title: "primavera", poem: "Cara mia, anche al tempo serve tempo e quindi tu fiorisci e sfiorisci secondo le tue stagioni. Chi ti ama ha la premura di aspettare i tuoi colori.", author: "Francesco Piscitelli"),
            Poem(title: "", poem: "Avrei potuto anche accontentarmi, ma è così che si diventa infelici.", author: "Charles Bukowski"),
            Poem(title: "", poem: "I libri pesano tanto: eppure, chi se ne ciba, e se li mette in corpo, vive tra le nuvole.", author: "Luigi Pirandello"),
            Poem(title: "", poem: "La paura di innamorarsi non è forse già un po' d'amore?", author: "Cesare Pavese"),
            Poem(title: "", poem: "Tutto ciò che ami probabilmente andrà perduto, ma alla fine l'amore tornerà in un altro modo.", author: "Franz Kafka"),
            Poem(title: "", poem: "Ho sceso, dandoti il braccio, almeno un milione di scale e ora che non ci sei è il vuoto ad ogni gradino.", author: "Eugenio Montale"),
            Poem(title: "", poem: "Il fatto è che certe cose le puoi dire solo a chi sai che le può capire. Che è anche il motivo per cui parliamo così poco, di quello che ci importa davvero.", author: "Enrico Galianio"),
            Poem(title: "MANUALE DELL'AMORE", poem: "Il primo amore non è la prima persona con cui ti fidanzi, ma la prima che ti ha dimostrato e fatto provare il vero amore.", author: "Anima Di Venere"),
            Poem(title: "MANUALE DELL'AMORE", poem: "L'unica persona con la quale ridendo un sacco il cuore ritorna finalmente a respirare.", author: "Anima Di Venere"),
            Poem(title: "", poem: "Sentirsi senza mai toccarsi. Ecco come le anime fanno l'amore quando i corpi sono altrove.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Io avevo voglia di stare da solo, perchè soltanto solo, sperduto, muto, a piedi, riesco a riconoscere le cose.", author: "Pier Paolo Pasolini"),
            Poem(title: "", poem: "Si guarisce da una sofferenza solo a condizione di sperimetarla pienamente.", author: "Marcel Proust"),
            Poem(title: "", poem: "Ero sul punto di troncare la conversazione, poichè nulla mi manda in bestia come il fatto che qualcuno se ne esca con luoghi comuni insignificanti mentre io sto parlando con tutto il cuore.", author: "J. W. Goethe"),
            Poem(title: "", poem: "Beati coloro che si baceranno sempre al di là delle labbra, varcando il confine del piacere, per cibarsi dei sogni..", author: "Alda Merini"),
            Poem(title: "", poem: "Di qualsiasi cosa siano fatte le nostre anime, la sua e la mia sono uguali.", author: "Emily Bronte"),
            Poem(title: "", poem: "La tristezza è causata dall'intelligenza. Più comprendi certe cose e più vorresti non comprenderle.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Non sopporto il pensiero che la mia vita stia scorrendo via così in fretta e che io in realtà non la viva.", author: "Ernest Hemingway"),
            Poem(title: "", poem: "Chi è sensibile, attribuisce un'importanza enorme ai dettagli più insignificanti del comportamento altri, quelli che generalmente sfuggono alle persone normali.", author: "Sigmund Freud"),
            Poem(title: "", poem: "Aveva il sorriso contagioso di chi aveva sofferto tanto. Era dannatamente bella, vestita dei suoi sbagli.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Invano il sognatore rovista nei suoi vecchi sogni, coma fra la cenere, cercandovi una piccola scintilla per soffiarci sopra e riscaldare col fuoco rinnovato il proprio cuore freddo, e far risorgere ciò che prima commuoveva la sua anima.", author: "Fëdor Dostoevskij"),
            Poem(title: "", poem: "E coloro che furono visti danzare vennero giudicati pazzi da quelli che non potevano sentire la musica.", author: "Friedrich Nietzsche"),
            Poem(title: "", poem: "I sogni si fanno di notte e si completano di giorno.", author: "Italo Svevo"),
            Poem(title: "", poem: "non c'è intimità più grande di poter essere sé stessi senza dover dimostrare di essere sempre all'altezza.", author: "Anonimo"),
            Poem(title: "Storie di ordinaria follia", poem: "L'anima libera è rara, ma la riconosci quando la vedi - essenzialmente perchè ti senti bene, molto bene, quando sei vicino a lei o insieme a lei.", author: "Charles Bukowski"),
            Poem(title: "senza averti qui", poem: "Dovresti essere orgogliosa di te stessa per il modo in cui hai affrontato quest'ultimo periodo: dalle battaglie silenziose che hai combattuto, fino ai momenti in cui sei caduta ma hai comunque deciso di rialzarti per l'ennesima volta e guardare avanti. Sei una guerriera. Perciò fatti un favore e celebra la tua forza.", author: "Sofia J. Ross"),
            Poem(title: "", poem: "Così tra questa immensità s'annega il pensier mio: e il naufragar m'è dolce in questo mare.", author: "Giacomo Leopardi"),
            Poem(title: "", poem: "Le menti superiori discutono le idee; le menti normali discutono gli eventi; le menti mediocri discutono le persone", author: "Socrate"),
            Poem(title: "", poem: "L'uomo che fa una domanda è uno sciocco per un minuto, l'uomo che non ne fa è uno sciocco per tutta la vita.", author: "Confucio"),
            Poem(title: "", poem: "L'uomo non conosce altra felicità se non quella che egli si va immaginando, e poi, finita l'illusione, ricade nel dolore di sempre.", author: "Sofocle"),
            Poem(title: "", poem: "un giorno mi sento come se stessi guarendo, il giorno dopo mi sto rompendo di nuovo. è come un ciclo che non ha fine.", author: "Anonimo"),
            Poem(title: "", poem: "Accetta le cose che non puoi cambiare, e cambia le cose che non puoi accettare.", author: "Marco Aurelio"),
            Poem(title: "", poem: "L'amore di un solitario è il più autentico che ci possa essere. Ti ama per scelta, non per compagnia.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Non sono sicuro di essere depresso. Voglio dire, non sono triste, ma non sono nemmeno esattamente felice. Posso ridere, scherzare e sorridere durante il giorno, ma quando sono solo di notte mi sento un po' insensibile.", author: "Anonimo"),
            Poem(title: "", poem: "Mi sento un po' come il mare: abbastanza calma per intraprendere nuovi rapporti umani, ma periodicamente in tempesta per allontanare tutti, per starmene sola.", author: "Alda Merini"),
            Poem(title: "", poem: "E' curioso a vedere che gli uomini di molto merito hanno sempre le maniere semplici, e che sempre le maniere semplici sono prese per indizio di poco merito.", author: "Giacomo Leopardi"),
            Poem(title: "", poem: "Ma tu chi sei che avanzando nel buio della notte inciampi nei miei più segreti pensieri?", author: "William Shakespeare"),
            Poem(title: "", poem: "I ricordi, come le candele, bruciano di più nel periodo natalizio.", author: "Charles Dickens"),
            Poem(title: "", poem: "A Natale non si fanno cattivi pensieri ma chi è solo lo vorrebbe saltare questo giorno. A tutti loro auguro di vivere un Natale in compagnia.", author: "Alda Merini"),
            Poem(title: "", poem: "ricordo ancora quanto era grande il mio sorriso la sera in cui tornai a casa dopo il nostro primo bacio.", author: "Anonimo"),
            Poem(title: "", poem: "Io penso che ci sia un eroe in tutti noi, che ci mantiene onesti, ci da forza, ci rende nobili... E alla fine ci permette di morire con dignità anche se a volte dobbiamo mostrare carattere e rinunciare alle cose che desideriamo di più, anche i nostri sogni...", author: "May Parker"),
            Poem(title: "", poem: "Non avevo da aggiungere altro verso, altra parola. Nel tuo corpo vivevo tutta la poesia.", author: "Ghiannis Ritsos"),
            Poem(title: "", poem: "Ma io sono predestinato ad avere l'anima perpetuamente in tempesta.", author: "Ugo Foscolo"),
            Poem(title: "Succede sempre qualcosa di meraviglioso", poem: "Purtroppo ormai c'è questa mentalità così fastidiosamente diffusa per cui \"semplice\" significhi di scarso valore, mentre \"complesso\" voglia dire prezioso. Non c'è niente di più falso. Le cose migliori della vita non sono complicate, anzi. Sono semplici.", author: "Gianluca Gotto"),
            Poem(title: "", poem: "Fai il meglio che puoi, con quello che hai, nel posto in cui sei.", author: "Theodore Roosevelt"),
            Poem(title: "Saro' con te.", poem: "Ti mandero' un bacio con il vento, affidandolo alle sue dolci carezze. Nel sussurro dell'aria, porterà il mio amore verso di te. Anche se non mi vedrai, saprai che sarò lì, sempre accanto a te.", author: "Sofia J. Ross"),
            Poem(title: "MANUALE DELL'AMORE", poem: "Un giorno incontri una persona, che può essere quando meno te lo aspetti, quando non cercavi niente, essa semplicemente appare e ti stravolge la vita.", author: "Anima Di Venere"),
            Poem(title: "Nonostante tutto...", poem: "Quando ti sentirai triste, nervosa, esausta, quando ci saranno giorni no... tu chiamami, non importa in che rapporti siamo, se ci odiamo, se ci amiamo, se ci vogliamo male. Sarò sempre pronto ad aiutarti, nonostante tutto...", author: "Anonimo"),
            Poem(title: "", poem: "Nessuno li ha mai visti con una cordicella che tenesse legati i loro polsi, certe cose non si vedono, ma esistono.", author: "José Saramago"),
            Poem(title: "", poem: "Era necessario un addio, perché capissi, che non c'è un addio per noi.", author: "Blaga Dimitrova"),
            Poem(title: "l'arcobaleno nei tuoi occhi", poem: "a volte mi domando se valga la pena lottare per un amore che la società condanna ma non riesco a immaginare la mia vita senza di te.", author: "Anonimo"),
            Poem(title: "", poem: "Mi chiedi parole. Ma il tempo precipita come un masso sulla mia anima che vuole certezze, e più non ha sillabe da offrire se non quelle silenziose del sangue legate al tuo nome, o mia vita, mio amore senza fine.", author: "Salvatore Quasimodo"),
            Poem(title: "", poem: "Le cose si ottengono quando non si desiderano più.", author: "Cesare Pavese"),
            Poem(title: "", poem: "Non rivangare quello che non può servire ad altro che a inquietarti inutilmente.", author: "Alessandro Manzoni"),
            Poem(title: "", poem: "Mai discutere con un idiota, ti porta al suo livello e ti batte con l'esperienza.", author: "Oscar Wilde"),
            Poem(title: "", poem: "Stare con te o stare senza di te è l'unico modo che ho per misurare il tempo.", author: "Jorge Luis Borges"),
            Poem(title: "L'Eco di quello che eri", poem: "Non voglio fare a meno di te, nemmeno per un istante. Ci incontrammo in una giornata normale, e tu l'hai trasformata in una vita importante.", author: "Anonimo"),
            Poem(title: "", poem: "Più mondo ho visto, meno mi sono costruito a suo gusto.", author: "Rousseau"),
            Poem(title: "", poem: "Hai disegnato ricordi nella mia mente. Non potrei mai cancellarli. Hai dipinto colori nel mio cuore. Non potrei mai sostituirlo.", author: "Anonimo"),
            Poem(title: "", poem: "Per essere felici bisognerebbe vivere. Ma vivere è la cosa più rara al mondo. La maggior parte della gente esiste, e nulla più.", author: "Oscar Wilde"),
            Poem(title: "", poem: "E se potessi prendere tutto il dolore dal tuo cuore e metterlo nel mio, lo farei.", author: "Anonimo"),
            Poem(title: "", poem: "Non vedo te nella Luna e nelle stelle, questo è cio che vedono i sognatori; Io vedo il tuo riflesso nei miei occhi, E ogni piccola cosa che faccio... Sei la mia realtà.", author: "Anonimo"),
            Poem(title: "", poem: "Mi accusate di avere dei vizi, di essere dissoluto, immorale, mentre io forse sono colpevole solo di essere più sincero degli altri e basta; di non nascondere ciò che gli altri nascondono persino a sé stessi.", author: "Fëdor Dostoevskij"),
            Poem(title: "", poem: "Chi combatte contro i mostri deve guardarsi dal non diventare egli stesso un mostro. Se guarderai a lungo in un abisso, anche l'abisso vorrà guardare dentro di te.", author: "Friedrich Nietzsche"),
            Poem(title: "", poem: "Non lasciatevi ingannare dalla nostalgia di \"quel che poteva essere\". Non poteva essere nient'altro, altrimenti lo sarebbe stato.", author: "Anonimo"),
            Poem(title: "", poem: "Per chi vuole vederli, ci sono fiori dappertutto.", author: "Henri Matisse"),
            Poem(title: "", poem: "E' meglio tenere la bocca chiusa e lasciare che le persone pensino che sei uno sciocco piuttosto che aprirla e togliere ogni dubbio.", author: "Mark Twain"),
            Poem(title: "", poem: "L'impossibile è per chi non vuole.", author: "John Keats"),
            Poem(title: "", poem: "Paradossalmente, la capacità di stare soli è la condizione prima per la capacità d'amare.", author: "Erich Fromm"),
            Poem(title: "", poem: "Visto che io non costringo nessuno, così non voglio essere costretto io stesso; io che rispetto la libertà altrui insisto sulla mia libertà.", author: "Van Gogh"),
            Poem(title: "", poem: "Quando una porta si chiude, un'altra si apre. Ma spesso guardiamo così a lungo e con tanto rimpianto la porta chiusa che non vediamo quella che si è aperta per noi.", author: "Alexander Graham Bell"),
            Poem(title: "", poem: "Ti manderò un bacio con il vento e so che lo sentirai, ti volterai senza vedermi ma io sarò lì.", author: "Pablo Neruda"),
            Poem(title: "", poem: "Quanto più lo spirito diventa gioioso e sicuro, tanto più l'uomo disimpara a ridere forte; per contro gli zampilla continuamente in viso un sorriso intelligente.", author: "Friedrich Nietzsche"),
            Poem(title: "", poem: "Il forse è la parola più bella del vocabolario italiano. Perché apre delle possibilità, non certezze. Perché non cerca la fine, ma va verso l'infinito.", author: "Giacomo Leopardi"),
            Poem(title: "", poem: "Più un uomo appare perfetto all'esterno, più demoni ha all'interno.", author: "Sigmund Freud"),
            Poem(title: "", poem: "Non ami qualcuno per il suo aspetto, i suoi vestiti o per la sua macchina da sogno, ma perchè canta una canzone che solo tu puoi sentire.", author: "Oscar Wilde"),
            Poem(title: "", poem: "Se oggi non valgo nulla, non varrò nulla nemmeno domani. Ma se domani scoprono in me dei valori, vuole dire che li posseggo anche oggi. Poichè il grano è grano, anche se la gente dapprima lo prende per erba.", author: "Van Gogh"),
            Poem(title: "", poem: "Un momento di pazienza in un momento di rabbia può salvare migliaia di momenti di rimpianti.", author: "Anonimo"),
            Poem(title: "", poem: "Prenderte la vita con leggerezza, che leggerezza non è superficialità, ma planare sulle cose dall'alto, non avere macigni sul cuore.", author: "Italo Calvino"),
            Poem(title: "", poem: "Amami quando lo merito meno, perchè sarà quando ne avrò più bisogno.", author: "Gaio Valerio Catullo"),
            Poem(title: "", poem: "Non tutte le tempeste arrivano per distruggerti la vita. Alcune arrivano per pulire il tuo cammino.", author: "Seneca"),
            Poem(title: "", poem: "Le nostre paure sono molto più numerose dei pericoli concreti che corriamo. Soffriamo molto di più per la nostra immaginazione che per la realtà.", author: "Seneca"),
            Poem(title: "", poem: "Per essere felici bisogna eliminare due cose: il timore di un male futuro e il ricordo di un male passato.", author: "Seneca"),
            Poem(title: "", poem: "E' gradevole stare con sè stessi il più a lungo possibile, se uno si è reso degno di essere di per sè soggetto di gioia.", author: "Seneca"),
            Poem(title: "", poem: "Con tre metodi possiamo imparare la saggezza: primo, mediante la riflessione, che è la più nobile; secondo, per imitazione, che è più facile; e terzo per esperienza che è più amara.", author: "Confucio"),
            Poem(title: "", poem: "La struttura alare del calabrone, in relazione al suo peso, non è adatta al volo, ma lui non lo sa e vola lo stesso.", author: "Albert Einstein"),
            Poem(title: "", poem: "Ho notato che anche le persone che affermano che tutto è già scritto e che non possiamo far nulla per cambiare il destino guardano a destra e a sinistra prima di attraversare la strada.", author: "Stephen Hawking"),
            Poem(title: "", poem: "Ogni volta che due persone si incontrano, ci sono sei persone presenti: come ogni persona vede se stessa, come una persona vede l'altra e ogni persona come realmente è.", author: "William James"),
            Poem(title: "", poem: "C'è una crepa in ogni cosa ed è da lì che entra la luce.", author: "Leonard Cohen"),
            Poem(title: "", poem: "Quando i 'vorrei' diventano 'voglio', quando i 'dovrei' diventano 'devo', quando i 'prima o poi' diventano 'adesso', allora e solo allora i desideri iniziano a trasformarsi in realtà.", author: "Anthony Robbins"),
            Poem(title: "", poem: "La vita non è misurata dal numero di respiri che prendiamo, ma dai momenti che ci lasciano senza fiato.", author: "Maya Angelou"),
            Poem(title: "", poem: "E' una malattia. La gente ha smesso di pensare, di provare emozioni, di interessarsi alle cose; nessuno che si appassioni o creda in qualcosa che non sia la sua piccola, dannata, comoda mediocrità.", author: "Richard Yates"),
            Poem(title: "", poem: "La conoscenza parla, ma la saggezza ascolta. Il vero apprendimento va oltre l'accumulo di informazioni, coinvolgendo una comprensione profonda e riflessiva.", author: "Jimi Hendrix"),
            Poem(title: "", poem: "Sopporta e resisti, un giorno questo dolore ti sarà utile.", author: "Ovidio"),
            Poem(title: "", poem: "Se vuoi costruire una barca, non radunare uomini per tagliare legna, dividere i compiti e impartire ordini, ma insegna loro la nostalgia per il mare vasto e infinito.", author: "Antoine de Saint-Exupèry"),
            Poem(title: "", poem: "Secondo la mitologia greca, gli umani originariamente furono creati con quattro braccia, quattro gambe e una testa con due facce. Temendo il loro potere, Zeus li divise in due parti separate, condannandoli a trascorrere le loro vite a cercare l'altra loro metà.", author: "Platone"),
            Poem(title: "", poem: "Tu sei quello che fai, non quello che dici che farai.", author: "Carl Jung"),
            Poem(title: "", poem: "E la fedeltà tra due persone che si amano... Ma che cos'è? Fedeltà vuol dire che qualsiasi cosa accada nella tua vita o nella mia. Io comunque ti sarò sempre vicino. Sarò sempre con te, io ci sarò.", author: "Roberto Benigni"),
            Poem(title: "", poem: "Il nostro è stato amore a prima vista, anzi ad ultima vista, anzi ad eterna vista.", author: "Roberto Benigni"),
            Poem(title: "", poem: "Non vedrei ora così bello, se già non avessi veduto così nero.", author: "Giovanni Pascoli"),
            Poem(title: "", poem: "Questo è ciò che significa fidarsi. Si tratta di dare a qualcun altro il potere su di te. Il potere di ferirti.", author: "Brandon Sanderson"),
            Poem(title: "", poem: "Coloro che sono capaci di vedere al di là delle ombre e delle menzogne della propria cultura non saranno mai compresi, figuriamoci creduti, dalle masse.", author: "Platone"),
            Poem(title: "", poem: "Non ti amo con il cuore e con la mente. Ti amo con l'anima, nel caso in cui la mia mente dimentichi e il mio cuore si fermi.", author: "Anonimo"),
            Poem(title: "", poem: "Certo che ti farò del male. Certo che me ne farai. Certo che ce ne faremo. Ma questa è la condizione stessa dell'esistenza. Farsi primavera, significa accettare il rischio dell'inverno. Farsi presenza, significa accettare il rischio dell'assenza.", author: "Piccolo Principe"),
            Poem(title: "", poem: "Chi ha naufragato trema anche di fronte ad acque tranquille.", author: "Ovidio"),
            Poem(title: "", poem: "Chi da luce, Rischia buio.", author: "Eugenio Montale"),
            Poem(title: "", poem: "Sei il mio \"niente\" quando la gente mi incontra Con lo sguardo perduto e mi chiede: a cosa stai pensando?", author: "Pablo Neruda"),
            Poem(title: "", poem: "Ho visto persone a pezzi aiutare chi aveva solo una crepa.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Attenti a quelli che cercano continuamente la folla, da soli non sono nessuno.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Ho visto persone a pezzi, aiutare chi aveva solo una crepa.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Mi manca. Glielo sto dicendo con tutto il silenzio di cui sono capace.", author: "Charles Bukowski"),
            Poem(title: "", poem: "A volte ho la sensazione di essere solo al mondo. Altre volte ne sono sicuro.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Alcune persone non impazziscono mai. Che vite davvero orribili devono condurre.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Quelli che aiuti ti distruggeranno.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Non cerco mai di migliorarmi o di imparare qualcosa, rimango esattamente come sono. Non sono uno che impara, sono uno che evita. Non ho voglia di imparare, mi sento perfettamente normale nel mio mondo pazzo; non voglio diventare come gli altri.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Amo i solitari, i diversi, quelli che non incontri mai. Quelli persi, andati, spiritati, f*ttuti. Quelli con l'anima in fiamme.", author: "Charles Bukowski"),
            Poem(title: "", poem: "E' inutile che vivi fuori se muori dentro.", author: "Zero Calcare"),
            Poem(title: "", poem: "E ricordati che cercare e pensare sono due cose diverse. Ed io ti penso ma non ti cerco.", author: "Charles Bukowski"),
            Poem(title: "", poem: "Brilla amore mio, brilla, voglio vederti brillare e raggiungere tutti gli obiettivi che secondo te meritano di essere raggiunti per tuo volere e non per volere di altri. Sarò sempre qui a tifare per te.", author: "Anonimo"),
            Poem(title: "", poem: "La fortuna non esiste. Esiste il momento in cui il talento incontra l'occasione.", author: "Seneca"),
            Poem(title: "", poem: "Un giorno tu ti sveglierai e vedrai una bella giornata. Ci sarà il sole, e tutto sarà nuovo, cambiato, limpido. Quello che prima ti sembrava impossibile diventerà semplice, normale. Non ci credi? Io sono sicuro. E presto. Anche domani.", author: "Fëdor Dostoevskij"),
            Poem(title: "", poem: "Date una compagnia al solitario e parlerà più di chiunque.", author: "Cesare Pavese"),
            Poem(title: "", poem: "Con te sono sdolcinato, romantico, buffo e infantile. Non è che io sia così, è che ti sei guadagnata quella parte di me. Ti amo.", author: "Anonimo"),
            Poem(title: "", poem: "Imparerai a tue spese che nel lungo tragitto della vita incontrerai tante maschere e pochi volti.", author: "Luigi Pirandello"),
            Poem(title: "", poem: "Non c'è più pazzo al mondo di chi crede d'aver ragione.", author: "Luigi Pirandello"),
            Poem(title: "", poem: "Hai mai pensato di andare via e non tornare mai più? Scappare e far perdere ogni tua traccia, per andare in un posto lontano e ricominciare a vivere, vivere una vita nuova, solo tua, vivere davvero. Ci hai mai pensato?", author: "Luigi Pirandello"),
            Poem(title: "", poem: "Prima di giudicare la mia vita o il mio carattere, mettiti le mie scarpe, percorri il cammino che ho percorso io. Vivi i miei dolori, i miei dubbi, le mie risate. Vivi gli anni che ho vissuto io e cadi là dove sono caduto io e rialzati come ho fatto io. Ognuno ha la propria storia. E solo allora mi potrai giudicare.", author: "Luigi Pirandello"),
            Poem(title: "", poem: "Gli occhi sono lo specchio dell'anima, cela i tuoi se non vuoi che ne scopra i segreti.", author: "Luigi Pirandello"),
            Poem(title: "", poem: "C'è una maschera per la famiglia, una per la società, una per il lavoro. E quando stai solo, resti nessuno.", author: "Luigi Pirandello"),
            Poem(title: "", poem: "Abbiamo tutti dentro un mondo di cose: ciascuno un suo mondo di cose! E come possiamo intenderci, signore, se nelle parole ch'io dico metto il senso e il valore delle cose come sono dentro di me; mentre chi le ascolta, inevitabilmente le assume col senso e col valore che hanno per sé, del mondo com'egli l'ha dentro? Crediamo di intenderci; non ci intendiamo mai!", author: "Luigi Pirandello"),
            Poem(title: "", poem: "Il maggior ostacolo del vivere è l'attesa, che dipende dal domani ma spreca l'oggi.", author: "Seneca"),
            Poem(title: "", poem: "Mi chiedi qual è stato il mio progresso? Ho cominciato a essere amico di me stesso.", author: "Seneca"),
            Poem(title: "", poem: "Chi aumenta il sapere, aumenta il dolore.", author: "Seneca"),
            Poem(title: "", poem: "Lieve è il dolore che parla, il grande dolore è muto.", author: "Seneca"),
            Poem(title: "", poem: "La fortuna non esiste: esiste il momento in cui il talento incontra l'opportunità.", author: "Seneca")
        ]
    }
    
    func getRandomPoem() -> Poem {
        return poems.randomElement() ?? poems[0]
    }
    
    func getShuffledPoems() -> [Poem] {
        return poems.shuffled()
    }
    
    func getUniqueAuthors() -> [String] {
        let authors = Set(poems.map { $0.author })
        return Array(authors).sorted()
    }
    
    func getPoemsByAuthor(_ author: String) -> [Poem] {
        return poems.filter { $0.author == author }
    }
    
    func getAuthorCount(_ author: String) -> Int {
        return getPoemsByAuthor(author).count
    }
}
