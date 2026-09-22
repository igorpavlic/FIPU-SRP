# Video prezentacija projekta — sinopsis i tekst

**Projekt:** Analiza helpdesk sustava i optimizacija procesa rješavanja ticketa
**Kolegij:** Skladišta i rudarenje podataka — Igor Pavlić, JMBAG 0069012453
**Trajanje:** do 10 minuta

---

## Sinopsis

Videoprezentacija prikazuje cjelovit proces izgradnje skladišta podataka nad stvarnim skupom od 66.691 helpdesk ticketa iz 15 projekata u periodu 2007.–2023. Kroz osam koraka — eksplorativnu analizu, predprocesiranje, relacijski model, dimenzijski model, ETL, vizualizaciju i validaciju generalizacije — pokazuje se kako se sirovi flat CSV pretvara u zvjezdastu shemu nad kojom se analitički upiti izvršavaju izravno u Power BI-ju.

Naglasak prezentacije nije na tehnologiji nego na uvidima koje model omogućuje. Tri su ključna nalaza: trećina dataseta su "ghost ticketi" koji nikad nisu ušli u stvarni workflow i medijanom rješavanja od preko šest godina drastično iskrivljuju sve prosjeke; dodjela tehničara je najjači prediktor brzine rješavanja s faktorom razlike od oko 190 puta; a ticketi ne kasne zbog aktivnog rada nego zbog čekanja u stanju `open`, gdje outlieri provode 94 puta više vremena od normalnih ticketa. Svi uvidi validirani su na izdvojenom 20% test skupu s odstupanjima manjim od 5%.

Prezentacija završava konkretnim preporukama za optimizaciju helpdesk procesa: smanjenje udjela ticketa bez prioriteta, brža dodjela assigneea i identifikacija ticketa koji dugo stoje bez ijednog procesnog koraka.

---

## Struktura s vremenima

| Vrijeme | Dio | Što je na ekranu |
|---------|-----|------------------|
| 0:00–0:40 | Uvod i cilj | Naslovnica seminara |
| 0:40–2:00 | EDA | `1_analysis.ipynb`, Slika 1 |
| 2:00–2:45 | Predprocesiranje i podjela 80/20 | `2_preprocess.ipynb`, Slika 2 |
| 2:45–3:50 | Relacijski model i import | ER dijagram, DESCRIBE output |
| 3:50–5:10 | Dimenzijski model | Star shema (Slika 5) |
| 5:10–6:30 | ETL proces | `6_ETL.ipynb`, verifikacija |
| 6:30–8:20 | Vizualizacija i uvidi | 4 Power BI dashboarda + heatmap |
| 8:20–9:10 | Generalizacija | Slika 13 i 14 |
| 9:10–10:00 | Zaključak i preporuke | Popis ključnih nalaza |

---

## Tekst za snimanje

### 0:00 — Uvod

> *[Naslovnica seminara]*

Pozdrav, ja sam Igor Pavlić i predstavljam projekt iz kolegija Skladišta i rudarenje podataka pod naslovom "Analiza helpdesk sustava i optimizacija procesa rješavanja ticketa".

Skup podataka koji sam koristio dolazi iz stvarnog helpdesk sustava i sadrži 66.691 ticket iz 15 projekata, u periodu od 2007. do 2023. godine. Za svaki ticket znamo tko ga je prijavio, tko ga je rješavao, kroz koja je stanja prošao, koliko je vremena proveo u svakom od njih i kako je završen.

Cilj projekta je proći cijeli put od sirovog CSV-a do skladišta podataka nad kojim se mogu postavljati analitička pitanja — i onda iz tog skladišta izvući konkretne poslovne uvide o tome gdje helpdesk proces zapinje.

### 0:40 — Eksplorativna analiza

> *[Notebook 1 / Slika 1]*

Prvi korak je eksplorativna analiza. Izvorni dataset ima 58 stupaca i ovdje se odmah vidi prvi problem: 16 od tih 58 stupaca ima više od 90 posto praznih vrijednosti. To su rijetko korišteni workflow statusi — `wf_deployment`, `wf_cancelled`, `wf_validation` i slični.

Drugi problem je ozbiljniji jer se tiče kvalitete samog procesa: 51 posto ticketa ima prioritet "unknown", a 47 posto uopće nema dodijeljenog tehničara.

Kad sam pogledao distribuciju vremena rješavanja, pokazalo se da dataset zapravo nije jedna populacija nego tri. Prva su takozvani "ghost ticketi" — otprilike trećina svih zapisa. To su ticketi koji imaju točno jedan procesni korak, nemaju prioritet, nemaju assigneea i medijan rješavanja im je preko 2.200 dana. Oni nikad nisu ni ušli u stvarni workflow. Druga skupina su aktivni ticketi s dodijeljenim tehničarom, njih oko 53 posto, s medijanom od devet dana. I treća, ostatak, oko 14 posto.

Ta podjela je ključna za sve dalje, jer objašnjava zašto je prosječno vrijeme rješavanja 18.441 sat, a medijan svega 835 sati. Prosjek u ovom datasetu nije upotrebljiva mjera.

### 2:00 — Predprocesiranje

> *[Notebook 2 / Slika 2]*

Predprocesiranje je zbog toga bilo namjerno konzervativno. Uklonio sam 16 stupaca s preko 90 posto NULL vrijednosti, čime je od 58 ostalo 42 stupca, standardizirao nazive u lowercase i provjerio duplikate — kojih nema.

Ono što nisam radio je izbacivanje outliera ili ghost ticketa, jer oni nisu greška u podacima nego nalaz. Da sam ih maknuo, izgubio bih najvažniji uvid cijele analize.

Na kraju sam dataset podijelio u omjeru 80 prema 20 s fiksnim seedom. 80 posto, odnosno 53.353 retka, ide u bazu i koristi se za cijeli dizajn, a 20 posto ostaje netaknuto za kasniju provjeru generaliziraju li se uvidi.

### 2:45 — Relacijski model

> *[ER dijagram, pa DESCRIBE output]*

Na konceptualnoj razini iz flat CSV-a izdvojio sam sedam entiteta: projekt, osobu, tip ticketa, prioritet, status, rezoluciju i centralnu tablicu support_ticket. Zanimljivo je da se entitet `person` referencira dvaput — jednom kao prijavitelj, jednom kao izvršitelj — pri čemu je veza prema izvršitelju obavezno nullable, jer 46 posto ticketa nema dodijeljenu osobu.

U MySQL je taj skup učitan kao staging tablica. Umjesto standardnog `to_sql`, koji datume sprema kao TEXT a identifikatore kao DOUBLE, definirao sam svih 42 SQL tipa eksplicitno — datumi kao DATETIME, ID-ovi kao INT, kategorije kao VARCHAR. Lozinka baze nigdje nije hardkodirana, čita se iz `.env` datoteke.

Nakon importa proveo sam pet provjera: broj redaka se poklapa, duplih ID-ova nema, NULL vrijednosti postoje samo tamo gdje ih očekujemo, mapiranje projekata je konzistentno i distribucije odgovaraju onima iz EDA faze.

### 3:50 — Dimenzijski model

> *[Slika 5 — star shema]*

Sljedeći korak je dimenzijski model. Zrno tablice činjenica je jedan helpdesk ticket, a shema ima pet dimenzija.

`dim_tehnicar` sa sto osoba koristi se dvostruko — i za reportera i za assigneea. `dim_projekt_prioritet_status` je junk dimenzija: umjesto tri zasebne male tablice, kombinirao sam projekt, prioritet i status u jednu. Teoretski maksimum je 15 puta 7 puta 15, dakle 1.575 kombinacija, ali u stvarnim podacima postoji samo njih 353. Dalje su `dim_tip_ticketa`, `dim_rezolucija` i vremenska dimenzija s otprilike 4.700 datuma.

Sve dimenzije koriste surrogate ključeve umjesto prirodnih — zbog stabilnosti identifikatora, bržih JOIN operacija i mogućnosti kasnije historizacije. DDL je generiran preko SQLAlchemy ORM-a, gdje je svaka tablica Python klasa.

Jedna praktična lekcija odavde: `CREATE TABLE IF NOT EXISTS` tiho preskače izmjene sheme, pa se pri iteriranju nad dizajnom uvijek mora eksplicitno raditi DROP prije CREATE.

### 5:10 — ETL

> *[Notebook 6 / Slika 6]*

ETL koristi dva izvora. Prvi je predprocesirani 80-postotni skup iz kojeg se grade sve dimenzije i tablica činjenica. Drugi je originalni puni dataset, iz kojeg vraćam onih 16 rijetkih workflow stupaca — jer iako imaju preko 90 posto NULL vrijednosti, za podskup ticketa sadrže stvarne podatke. Recimo, `wf_validation` ima gotovo tri tisuće ispunjenih zapisa. Ta dva izvora spajaju se LEFT JOIN-om po ID-u, čime se čuva svih 53.353 ticketa.

U transformaciji se sve workflow metrike pretvaraju iz sekundi u sate. Da potvrdim da je jedinica doista sekunda, provjerio sam to ručno: ticket 11887 ima `wf_total_time` 1992, a razlika između vremena kreiranja i rezolucije je točno 1992 sekunde, odnosno 33 minute i 12 sekundi.

Kod mapiranja stranih ključeva jedan detalj je bio kritičan. Inicijalno sam za assigneea koristio inner join i tiho izgubio 46 posto redaka. Prelaskom na LEFT JOIN za assigneea i za rezoluciju svi redci su sačuvani, a to je na kraju osigurano i programski, assertom da fact tablica ima točno 53.353 retka.

### 6:30 — Vizualizacija i uvidi

> *[Dashboard 1]*

Vizualizacija je napravljena u Power BI-ju nad denormaliziranim upitom preko star sheme, kroz četiri stranice.

Prva stranica daje pregled sustava — 53 tisuće ticketa, 15 projekata, prosjek 18 tisuća sati i medijan 835. Već tu se vidi ono što smo naslutili u EDA fazi: razlika između prosjeka i medijana je dvadeseterostruka.

> *[Dashboard 2 i Slika 11]*

Druga stranica je analiza outliera. Prag sam postavio na 95. percentil unutar ticketa s poznatim prioritetom, što ispada 6.499 sati ili 271 dan. Preko tog praga je 1.275 ticketa.

Najzanimljiviji nalaz je gdje ti ticketi troše vrijeme. U stanju `open` outlieri provode 94 puta više vremena od normalnih ticketa, u `in progress` 29 puta, a u `waiting` 12 puta. Znači, ticketi ne kasne zato što se na njima dugo radi — kasne zato što nikad nisu ni preuzeti.

Uz to se vidi jedna kontraintuitivna stvar: ticketi prioriteta "Lowest" prosječno čekaju 2.324 sata, dok Blocker ticketi čekaju 256. Najniži prioritet čeka gotovo deset puta dulje od kritičnog, što je zapravo očekivano, ali ovdje je i kvantificirano.

> *[Dashboard 3 i 4]*

Treća stranica pokazuje distribucije — matricu projekt puta prioritet, gdje "unknown" dominira u svim projektima, i podatak da 41 posto ticketa traje dulje od tri mjeseca.

Četvrta stranica je posvećena kvaliteti podataka i tu je najvažniji broj cijelog projekta: ticketi bez dodijeljenog tehničara imaju medijan rješavanja otprilike 190 puta duži od onih s tehničarom. To nije korelacija koju treba tražiti dubinskom analizom — to je razlika između devet dana i preko četiri godine.

### 8:20 — Generalizacija

> *[Slika 13 i 14]*

Ostaje pitanje jesu li ti uvidi stvarni ili artefakt uzorkovanja. Zato sam ih provjerio na onih 20 posto podataka koje baza nikad nije vidjela.

Prosječno vrijeme rješavanja razlikuje se za 1,1 posto, medijan za 2,7 posto, udio ticketa bez prioriteta za tri desetinke postotnog boda. Udio ghost ticketa je 32,3 naspram 33,2 posto. Efekt assigneea je 186 puta na treningu i 203 puta na testu — dakle stabilnih otprilike 190. Korelacija broja koraka i vremena rješavanja je minus 0,463 naspram minus 0,464.

Jedina nestabilnost je u kategorijama Blocker i Low, gdje medijani odstupaju i do 30 posto — ali te kategorije imaju manje od 600 ticketa, pa je to očekivano.

Zaključak je da uvidi generaliziraju.

### 9:10 — Zaključak

> *[Popis nalaza]*

Da sažmem. Prvo: trećina dataseta su ticketi koji nikad nisu ušli u proces i koji sami iskrivljuju sve prosjeke sustava. Drugo: prioritet funkcionira kad je postavljen — ticketi s poznatim prioritetom rješavaju se u medijanu od osam dana. Treće: dodjela tehničara je najjači pojedinačni prediktor, s faktorom od oko 190. Četvrto: uska grla nisu u radu nego u čekanju, prije svega u stanju `open`.

Iz toga slijede tri konkretne preporuke: obavezan prioritet pri otvaranju ticketa, automatska dodjela assigneea u nekom razumnom roku i redovito čišćenje ticketa koji su duže vrijeme na jednom koraku.

Hvala na pažnji.

---

## Napomene za snimanje

- Tekst ima približno 1.500 riječi, što pri normalnom tempu izlaganja iznosi 9 do 10 minuta. Ako ide predugo, prvo skrati dio o relacijskom modelu (2:45–3:50) — to je najmanje zanimljiv dio priče.
- Brojeve izgovaraj zaokruženo ("osamnaest tisuća sati", ne "18.441"), osim gdje je preciznost poanta (1992 sekunde, faktor 190).
- Dio o LEFT JOIN grešci i o `CREATE TABLE IF NOT EXISTS` ostavi — profesori vole kad se vidi da si naletio na problem i riješio ga.
- Na dashboardima ne čitaj sve grafove; pokaži jedan i objasni što iz njega slijedi.
- Ako snimaš screen recording, drži otvoren seminar u jednom prozoru i Power BI u drugom, pa preklapaj — prebacivanje po notebookovima usred snimanja gubi vrijeme.
